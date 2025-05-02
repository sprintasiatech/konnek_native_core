import 'dart:convert';

class AppFileHelper {
  static String getUrlName(String payload) {
    // AppLoggerCS.debugLog("widget.data.payload: $payload");
    String data = jsonDecode(payload)['url'];
    // AppLoggerCS.debugLog("getUrlName: $data");
    return data;
  }

  static String getFileNameFromUrl(String payload) {
    String data = (jsonDecode(payload)['url'] as String).split("/").last;
    // AppLoggerCS.debugLog("getFileNameFromUrl: $data");
    return data;
  }
}
