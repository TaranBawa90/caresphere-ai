import 'package:url_launcher/url_launcher.dart';
import '../constants/api_constants.dart';

class EmergencyService {
  static Future<bool> dialEmergencyNumber(String number) async {
    final clean = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        return await launchUrl(uri);
      } catch (_) {}
    }
    return false;
  }

  static Future<bool> openMapDirections({
    required double latitude,
    required double longitude,
    required String destinationName,
  }) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        return await launchUrl(url);
      } catch (_) {}
    }
    return false;
  }

  static Future<bool> launchJitsiRoom(String roomId) async {
    final cleanRoom = roomId.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    final url = Uri.parse('${ApiConstants.jitsiServerUrl}/$cleanRoom#config.prejoinPageEnabled=false');
    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        return await launchUrl(url);
      } catch (_) {}
    }
    return false;
  }
}
