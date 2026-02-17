import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  // Constructeur privé pour empêcher l'instanciation de la classe
  LauncherUtils._();

  /// Ouvre une URL dans un nouvel onglet du navigateur
  static Future<void> openUrl(String urlString) async {
    if (urlString.isEmpty) return;

    final Uri url = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw NotFoundException("URL", urlString);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
