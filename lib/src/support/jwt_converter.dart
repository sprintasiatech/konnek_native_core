import 'dart:convert';

import 'package:konnek_native_core/src/support/app_logger.dart';

class JwtConverter {
  Map<String, dynamic> decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw FormatException('Invalid JWT format');
      }

      final header = _decodeJwtPart(parts[0]);
      final payload = _decodeJwtPart(parts[1]);
      final signature = parts[2];

      return {
        'header': header,
        'payload': payload,
        'signature': signature,
      };
    } catch (e) {
      AppLoggerCS.debugLog("[decodeJwt] error: $e");
      rethrow;
    }
  }

  Map<String, dynamic> _decodeJwtPart(String part) {
    // Add padding if needed
    String padded = part.padRight((part.length + 3) ~/ 4 * 4, '=');
    String jsonString = utf8.decode(base64Url.decode(padded));
    return json.decode(jsonString);
  }
}
