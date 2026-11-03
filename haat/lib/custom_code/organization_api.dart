import '/custom_code/api_result.dart';
import '/custom_code/api_client.dart';
import '/custom_code/api_config.dart';

/// One choice on a business-setup screen, in both languages.
class BusinessOption {
  const BusinessOption({
    required this.key,
    required this.label,
    required this.labelAr,
    this.icon,
  });

  /// What the backend stores and validates against, and the only part it accepts.
  ///
  /// Never shown to anyone. `PATCH /organizations` checks the submitted categories
  /// against its own list and refuses anything else, so a screen that sends what it
  /// displays — "🍽️ Food" — is refused with a validation error that reads as though
  /// the merchant did something wrong.
  final String key;

  final String label;
  final String labelAr;

  /// Material icon name the back office chose, or null to let the screen decide.
  ///
  /// A name rather than an asset path: an asset has to be bundled with a release, which
  /// would leave every option the back office adds as the only row on the screen with a
  /// blank where the others have a picture.
  final String? icon;

  /// The label in [languageCode], falling back to English when Arabic is absent.
  String labelIn(String languageCode) =>
      languageCode == 'ar' && labelAr.isNotEmpty ? labelAr : label;

  factory BusinessOption.fromData(Map<String, dynamic> data) => BusinessOption(
        key: data['key'] as String? ?? '',
        label: data['label'] as String? ?? '',
        labelAr: data['labelAr'] as String? ?? '',
        icon: (data['icon'] as String?)?.trim().isEmpty ?? true
            ? null
            : (data['icon'] as String).trim(),
      );
}

/// The two lists the business-setup screens render.
class BusinessSetupOptions {
  const BusinessSetupOptions({
    required this.categories,
    required this.salesChannels,
  });

  /// "What do you want to sell?" — multi-select.
  final List<BusinessOption> categories;

  /// "Where would you like to sell?" — single-select.
  final List<BusinessOption> salesChannels;

  factory BusinessSetupOptions.fromData(Map<String, dynamic> data) =>
      BusinessSetupOptions(
        categories: _optionsIn(data['categories']),
        salesChannels: _optionsIn(data['salesChannels']),
      );

  /// Tolerant of a payload that has moved on: an entry without a key is dropped
  /// rather than rendered as a chip that cannot be saved.
  static List<BusinessOption> _optionsIn(dynamic value) => value is List
      ? value
          .whereType<Map<String, dynamic>>()
          .map(BusinessOption.fromData)
          .where((option) => option.key.isNotEmpty)
          .toList(growable: false)
      : const <BusinessOption>[];
}

/// The business a merchant is setting up.
///
/// The option lists are the backend's, not the app's. They are nine categories and
/// five channels that the dashboard, the reports and the admin console all agree on;
/// a copy in the app would be a second list that drifts the first time one of them
/// gains an entry, and every merchant who picked from the stale copy would have
/// their answer refused at save time.
class OrganizationApi {
  OrganizationApi(this._client);

  final ApiClient _client;

  /// The last successful answer, held for the life of the session.
  ///
  /// Two screens ask for this back to back — "where do you sell" and "what do you
  /// sell" — and the answer is a constant on the server. Fetching it twice would
  /// put a second spinner in front of a merchant for a list that cannot have
  /// changed in between.
  ///
  /// The whole [ApiSuccess] is kept rather than its value: [ApiResult] is sealed, so
  /// a cache hit has to *be* one of the three shapes, and building a fresh success
  /// would need an envelope this class has no business inventing.
  ApiSuccess<BusinessSetupOptions>? _cached;

  /// The choices the setup screens offer.
  ///
  /// Authenticated: the merchant has registered and verified by the time these
  /// screens appear, so the token is in hand.
  ///
  /// A failure is not cached. The common one is a token that has just expired, and
  /// remembering it would keep the screens empty for the rest of the session.
  Future<ApiResult<BusinessSetupOptions>> setupOptions(
      {bool refresh = false}) async {
    final held = _cached;
    if (held != null && !refresh) return held;

    final result = await _client.get(
      '/organizations/setup-options',
      parse: (envelope) => BusinessSetupOptions.fromData(envelope.object),
    );

    if (result is ApiSuccess<BusinessSetupOptions>) _cached = result;

    return result;
  }

  /// Whether this account already has a business, and which one.
  ///
  /// Returns null when it has none, which is the ordinary state through the whole of
  /// onboarding — a merchant registers as a person and becomes a business later.
  ///
  /// The endpoint answers with a bare array — one entry per business this account can
  /// act in — so it is read as a list. It was read as an object at first, which comes
  /// back empty for an array, which meant this always said "none": a merchant who
  /// tapped Continue twice was sent to register the same business a second time and
  /// stopped by the handle already being taken.
  ///
  /// The owned one is preferred. Staff can act in a business without owning it, and
  /// the setup screens are about the merchant's own.
  Future<ApiResult<String?>> currentOrganizationId() => _client.get(
        '/organizations',
        parse: (envelope) {
          final rows = envelope.list.whereType<Map<String, dynamic>>().toList();
          if (rows.isEmpty) return null;

          final owned = rows.where((row) => row['isOwner'] == true);
          final chosen = owned.isNotEmpty ? owned.first : rows.first;

          return chosen['organizationId'] as String?;
        },
      );

  /// Registers the business, with its first branch, and makes this account its owner.
  ///
  /// **The token in hand goes stale.** It was minted before this account had any
  /// permission over any business, so the caller has to refresh before the very next
  /// request — which is why [AuthSession.createOrganization] does that rather than
  /// leaving it to each screen to remember.
  ///
  /// [slug] is the platform-wide handle and has to be unique; a clash comes back as a
  /// 409 for the caller to resolve, because only they know whether to try another name
  /// or another handle.
  Future<ApiResult<String>> create({
    required String name,
    required String slug,
    String? category,
  }) =>
      _client.post(
        '/organizations',
        body: {
          'name': name,
          'slug': slug,
          if (category != null) 'category': category,
        },
        parse: (envelope) => envelope.object['organizationId'] as String,
      );

  /// Saves what the business sells, where it sells, and where it is.
  ///
  /// One call for three screens, matching the endpoint: every field is optional, so a
  /// screen sends only its own answer and a merchant who stops halfway leaves nothing
  /// half-written.
  ///
  /// [categories] and [salesChannels] carry **keys**, never labels — the backend checks
  /// them against its own catalogue, which is the same catalogue [setupOptions]
  /// returned.
  Future<ApiResult<bool>> updateProfile({
    String? name,
    List<String>? categories,
    List<String>? salesChannels,
    String? addressLine,
    String? city,
    double? latitude,
    double? longitude,
  }) =>
      _client.patch(
        '/organizations',
        body: {
          if (name != null) 'name': name,
          if (categories != null) 'categories': categories,
          if (salesChannels != null) 'salesChannels': salesChannels,
          if (addressLine != null) 'addressLine': addressLine,
          if (city != null) 'city': city,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
        parse: (_) => true,
      );

  /// Sets the business's logo. Returns the address it can now be fetched from.
  ///
  /// PNG, JPEG or WebP, up to 512 KB. The server decides what kind of file it is from
  /// the bytes themselves, so there is nothing to declare here.
  Future<ApiResult<String>> uploadLogo({
    required List<int> bytes,
    required String filename,
  }) =>
      _client.postFile(
        '/organizations/logo',
        bytes: bytes,
        filename: filename,
        parse: (envelope) =>
            logoUrlFor(envelope.object['logoPath'] as String?) ?? '',
      );

  /// Where the merchant's own business stands with HAAT: `pending` until the back
  /// office approves it, `active` once it has, `suspended` if it has been stopped.
  /// Null when this account has no business yet.
  Future<ApiResult<String?>> currentStatus() => _client.get(
        '/organizations',
        parse: (envelope) {
          final rows = envelope.list.whereType<Map<String, dynamic>>().toList();
          if (rows.isEmpty) return null;

          final owned = rows.where((row) => row['isOwner'] == true);
          final chosen = owned.isNotEmpty ? owned.first : rows.first;

          return chosen['status'] as String?;
        },
      );

  /// The business's current logo address, or null if it has none yet.
  Future<ApiResult<String?>> currentLogoUrl() => _client.get(
        '/organizations',
        parse: (envelope) {
          final rows = envelope.list.whereType<Map<String, dynamic>>().toList();
          if (rows.isEmpty) return null;

          final owned = rows.where((row) => row['isOwner'] == true);
          final chosen = owned.isNotEmpty ? owned.first : rows.first;

          return logoUrlFor(chosen['logoPath'] as String?);
        },
      );

  /// Forgets the cached lists. Called when the session ends, so the next merchant
  /// on this handset does not read the previous one's copy.
  void forget() => _cached = null;
}

/// Turns the path the backend hands back into an address an image can load from.
///
/// The backend returns a path because it cannot know the address the app reached it
/// by — the same gateway answers on a local address in development and a public one
/// in production. So the path is joined to whatever [ApiConfig.baseUrl] the app is
/// actually using.
///
/// No token is attached, and none is needed: a logo is branding, served to anyone,
/// which is also what lets an ordinary network image draw it.
String? logoUrlFor(String? path) {
  if (path == null || path.isEmpty) return null;

  return '${ApiConfig.baseUrl}$path';
}

/// Turns a business name into the handle the platform stores.
///
/// `Souq Al Madina` becomes `souq-al-madina`, which is the shape `POST /organizations`
/// insists on — lowercase words joined by single hyphens.
///
/// Derived rather than asked for. A handle is a technical detail of the platform, and
/// a merchant typing their shop's name has no reason to also invent a URL-safe version
/// of it. Uniqueness is still the backend's to enforce: a clash comes back as a 409,
/// which the caller resolves rather than this guessing at a suffix.
String handleFor(String businessName) {
  final slug = businessName
      .toLowerCase()
      .replaceAll(RegExp(r"[^a-z0-9]+"), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');

  // A name with nothing a handle can be built from — all Arabic, say, which is the
  // ordinary case here. The platform needs *something* unique, and the alternative is
  // refusing a merchant their own shop's name.
  return slug.isEmpty
      ? 'shop-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}'
      : slug;
}
