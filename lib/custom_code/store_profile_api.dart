import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';

/// What the Profile tab says about the business, read from the server.
///
/// Every figure on that tab was the design's — "Lipper Pizza", 1,284 orders, five staff,
/// "Verified" — the same for every merchant. This gathers the real ones from the calls
/// that already exist; none of them is new.
class StoreProfile {
  const StoreProfile({
    required this.name,
    required this.handle,
    required this.logoPath,
    required this.status,
    required this.orders,
    required this.products,
    required this.outOfStock,
    required this.staff,
    required this.branches,
    required this.branchNames,
    required this.kybStatus,
  });

  final String name;
  final String handle;
  final String? logoPath;
  final String status;

  /// Payments the business has received, counted up to [ordersCap].
  final int orders;
  final int products;
  final int outOfStock;
  final int staff;
  final int branches;
  final List<String> branchNames;

  /// The business documents case: draft, submitted, approved, rejected — or none.
  final String kybStatus;

  // The most /transactions returns in one page.
  static const ordersCap = 100;

  Map<String, dynamic> toJson() => {
        'name': name,
        'handle': handle,
        'logoPath': logoPath,
        'status': status,
        'orders': orders >= ordersCap ? '$ordersCap+' : '$orders',
        'products': '$products',
        'staff': '$staff',
        'productsLine': outOfStock == 0
            ? _count(products, 'product', 'products')
            : '${_count(products, 'product', 'products')} · $outOfStock out of stock',
        'staffLine': _count(staff, 'person', 'people'),
        'branchesLine': branchNames.isEmpty
            ? _count(branches, 'branch', 'branches')
            : '${_count(branches, 'branch', 'branches')} · ${branchNames.join(', ')}',
        'kybLine': 'Licence, owner ID and documents · ${_kybWord(kybStatus)}',
      };

  static String _count(int n, String one, String many) =>
      '$n ${n == 1 ? one : many}';

  static String _kybWord(String status) => switch (status) {
        'approved' => 'Verified',
        'submitted' || 'in_review' || 'review' => 'In review',
        'rejected' => 'Needs changes',
        _ => 'Not submitted',
      };
}

class StoreProfileApi {
  StoreProfileApi(this._client);

  final ApiClient _client;

  /// Null when the account has no business yet, or the server could not be reached.
  Future<StoreProfile?> load() async {
    final org = await _client.get<Map<String, dynamic>?>(
      '/organizations',
      parse: (envelope) {
        final data = envelope.data;
        return data is List &&
                data.isNotEmpty &&
                data.first is Map<String, dynamic>
            ? data.first as Map<String, dynamic>
            : null;
      },
    );
    final business = org.valueOrNull;
    if (business == null) return null;

    // The rest only fill in figures; one failing leaves its figure at zero rather
    // than the whole tab empty.
    final lists = await Future.wait([
      _list('/products'),
      _list('/organizations/staff'),
      _list('/organizations/branches'),
      _list('/transactions', query: {'limit': '${StoreProfile.ordersCap}'}),
    ]);
    final products = lists[0],
        staff = lists[1],
        branches = lists[2],
        payments = lists[3];
    final active = branches.where((b) => b['status'] != 'closed').toList();

    final kyb = await _client.get<String>(
      '/kyc/organization',
      parse: (envelope) {
        final data = envelope.data;
        return data is Map<String, dynamic> ? '${data['status'] ?? ''}' : '';
      },
    );

    return StoreProfile(
      name: '${business['name'] ?? ''}',
      handle: '${business['slug'] ?? ''}',
      logoPath: business['logoPath'] as String?,
      status: '${business['status'] ?? ''}',
      orders: payments
          .where((p) => '${p['direction'] ?? 'credit'}' == 'credit')
          .length,
      products: products.length,
      outOfStock: products.where((p) => p['outOfStock'] == true).length,
      staff: staff.length,
      branches: active.length,
      branchNames: active
          .map((b) => '${b['name'] ?? ''}')
          .where((n) => n.isNotEmpty)
          .toList(),
      kybStatus: kyb.valueOrNull ?? '',
    );
  }

  Future<List<Map<String, dynamic>>> _list(String path,
      {Map<String, String>? query}) async {
    final result = await _client.get<List<Map<String, dynamic>>>(
      path,
      query: query,
      parse: (envelope) {
        final data = envelope.data;
        return (data is List ? data : const [])
            .whereType<Map<String, dynamic>>()
            .toList();
      },
    );
    return result.valueOrNull ?? const [];
  }
}
