enum Flavor { development, staging, production }

class EnvironmentConfig {
  static Flavor flavor = Flavor.staging;

  static String _baseUrl = "";

  static String get customBaseUrl {
    if (_baseUrl.isEmpty || _baseUrl == "") {
      switch (flavor) {
        case Flavor.development:
          return "http://192.168.1.74:8080";
        case Flavor.staging:
          return "https://stg.wekonnek.id:9443";
        default:
          return "https://wekonnek.id:9443";
      }
    }
    return _baseUrl;
  }

  static set customBaseUrl(String val) {
    _baseUrl = val;
  }

  static String baseUrl() {
    return customBaseUrl;
  }

  static String _baseUrlSocket = "";

  static String get customBaseUrlSocket {
    if (_baseUrlSocket.isEmpty || _baseUrlSocket == "") {
      switch (flavor) {
        case Flavor.development:
          return "http://192.168.1.74:3000";
        case Flavor.staging:
          return "https://stgsck.wekonnek.id:3001";
        default:
          return "https://sck.wekonnek.id:3001";
      }
    }
    return _baseUrlSocket;
  }

  static set customBaseUrlSocket(String val) {
    _baseUrlSocket = val;
  }

  static String baseUrlSocket() {
    return customBaseUrlSocket;
  }
}
