import '/custom_code/api_result.dart';
import '/custom_code/api_client.dart';

/// One choice on a business-setup screen, in both languages.
class BusinessOption {
  const BusinessOption({
    required this.key,
    required this.label,
    required this.labelAr,
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

  /// The label in [languageCode], falling back to English when Arabic is absent.
  String labelIn(String languageCode) =>
      languageCode == 'ar' && labelAr.isNotEmpty ? labelAr : label;

  factory BusinessOption.fromData(Map<String, dynamic> data) => BusinessOption(
        key: data['key'] as String? ?? '',
        label: data['label'] as String? ?? '',
        labelAr: data['labelAr'] as String? ?? '',
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

  /// Forgets the cached lists. Called when the session ends, so the next merchant
  /// on this handset does not read the previous one's copy.
  void forget() => _cached = null;
}
