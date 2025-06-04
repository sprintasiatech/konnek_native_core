import 'dart:convert';

class AppFileHelper {
  static String getUrlName(String payload) {
    String data = jsonDecode(payload)['url'];
    return data;
  }

  static String getFileNameFromUrl(String payload) {
    String data = (jsonDecode(payload)['url'] as String).split("/").last;
    return data;
  }
}
