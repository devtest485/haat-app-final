import '/custom_code/api_client.dart';
import '/custom_code/api_config.dart';
import '/custom_code/api_result.dart';

/// One card on the home screen, as the platform maintains it.
///
/// The three the design drew were pictures compiled into the app, so changing what the
/// platform tells its merchants — or taking a card down for a feature that is not ready
/// — cost a release. They are rows now; this is one of them.
class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.subtitle,
    required this.subtitleAr,
    required this.imageUrl,
    required this.backgroundColor,
    required this.actionRoute,
  });

  final String id;
  final String title;
  final String titleAr;
  final String subtitle;
  final String subtitleAr;

  /// Where the artwork is, or empty for a card that is a headline on a colour.
  final String imageUrl;

  /// `#RRGGBB`, as the back office set it.
  final String backgroundColor;

  /// The screen a tap opens, by the app's own route name, or empty for a card that
  /// only announces something.
  final String actionRoute;

  String titleIn(String languageCode) =>
      languageCode == 'ar' && titleAr.isNotEmpty ? titleAr : title;

  String subtitleIn(String languageCode) =>
      languageCode == 'ar' && subtitleAr.isNotEmpty ? subtitleAr : subtitle;

  factory HomeBanner.fromData(Map<String, dynamic> data) {
    final path = (data['imagePath'] as String?) ?? '';

    return HomeBanner(
      id: data['id'] as String? ?? '',
      title: data['title'] as String? ?? '',
      titleAr: data['titleAr'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      subtitleAr: data['subtitleAr'] as String? ?? '',
      // Relative when it is there at all, like a logo's: the server names the route,
      // the app knows which server it is talking to.
      imageUrl: path.isEmpty ? '' : '${ApiConfig.baseUrl}$path',
      backgroundColor: data['backgroundColor'] as String? ?? '#0b6b3a',
      actionRoute: data['actionRoute'] as String? ?? '',
    );
  }
}

/// The cards the home screen shows.
class BannerApi {
  BannerApi(this._client);

  final ApiClient _client;

  /// The live cards, in the order the back office set.
  ///
  /// An empty list is an ordinary answer, not a failure: it means the platform has
  /// nothing to say today, and the home screen simply has no cards on it.
  Future<ApiResult<List<HomeBanner>>> list() => _client.get(
        '/banners',
        parse: (envelope) => envelope.list
            .whereType<Map<String, dynamic>>()
            .map(HomeBanner.fromData)
            .toList(),
      );
}
