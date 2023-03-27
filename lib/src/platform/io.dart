import 'package:light_logger/light_logger.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Use login with providers on different devices
class CMSPlatform {
  /// Use login with providers on different devices
  static Future login(
    final String url,
    final Function(String) callback,
  ) async {
    Logger.printMessage(url);
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.inAppWebView,
      );
      await callback('');
    }
  }
}
