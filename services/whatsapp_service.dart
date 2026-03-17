import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {

  static Future<void> sendMessage(String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final uri = Uri.parse("https://wa.me/?text=$encodedMessage");

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not open WhatsApp';
    }
  }
}
