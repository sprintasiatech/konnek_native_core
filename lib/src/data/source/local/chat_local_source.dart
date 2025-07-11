import 'dart:convert';


import 'package:konnek_native_core/inter_module.dart';
import 'package:konnek_native_core/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/send_chat_response_model.dart';
import 'package:konnek_native_core/src/support/app_logger.dart';
import 'package:konnek_native_core/src/support/local_service_hive.dart';

class LocalKey {
  static const String accessToken = "accessToken";
  static const String clientData = "clientData";
  static const String supportData = "supportData";
  static const String configData = "configData";
  static const String socketReady = "socketReady";
}

class ChatLocalSource {
  // final LocalServiceHive localServiceHive;
  // ChatLocalSource(this.localServiceHive);

  static LocalServiceHive localServiceHive = InterModule.localServiceHive;

  Future<void> setSocketReady(bool value) async {
    try {
      await localServiceHive.user.putSecure(
        key: LocalKey.socketReady,
        data: value,
      );
    } catch (e) {
      AppLoggerCS.debugLog("[setConfigData] error: $e");
      rethrow;
    }
  }

  Future<bool?> getSocketReady() async {
    try {
      bool? value = await localServiceHive.user.getSecure(
        key: LocalKey.socketReady,
      );
      if (value != null) {
        return value;
      } else {
        return null;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[getSocketReady] error: $e");
      return null;
    }
  }

  Future<void> setConfigData(DataGetConfig value) async {
    try {
      String data = jsonEncode(value.toJson());
      await localServiceHive.user.put(
        LocalKey.configData,
        data,
      );
    } catch (e) {
      AppLoggerCS.debugLog("[setConfigData] error: $e");
      rethrow;
    }
  }

  Future<DataGetConfig?> getConfigData() async {
    try {
      String? value = await localServiceHive.user.get(
        LocalKey.configData,
      );
      if (value != null) {
        Map<String, dynamic> formatMap = jsonDecode(value);
        DataGetConfig data = DataGetConfig.fromJson(formatMap);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[getConfigData] error: $e");
      return null;
    }
  }

  Future<void> setSupportData(DataSendChat value) async {
    try {
      String data = jsonEncode(value.toJson());
      await localServiceHive.user.putSecure(
        key: LocalKey.supportData,
        data: data,
      );
    } catch (e) {
      AppLoggerCS.debugLog("[setSupportData] error: $e");
      rethrow;
    }
  }

  Future<DataSendChat?> getSupportData() async {
    try {
      String? value = await localServiceHive.user.getSecure(
        key: LocalKey.supportData,
      );
      if (value != null) {
        Map<String, dynamic> formatMap = jsonDecode(value);
        DataSendChat data = DataSendChat.fromJson(formatMap);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[getSupportData] error: $e");
      return null;
    }
  }

  Future<void> setAccessToken(String value) async {
    try {
      await localServiceHive.user.putSecure(
        key: LocalKey.accessToken,
        data: value,
      );
    } catch (e) {
      AppLoggerCS.debugLog("[setAccessToken] error: $e");
      rethrow;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      String? value = await localServiceHive.user.getSecure(
        key: LocalKey.accessToken,
      );
      return value;
    } catch (e) {
      AppLoggerCS.debugLog("[getAccessToken] error: $e");
      return null;
    }
  }

  Future<void> setClientData({
    required String name,
    required String email,
  }) async {
    try {
      Map<String, dynamic> formatMap = {
        "name": name,
        "username": email,
      };
      String jsonString = jsonEncode(formatMap);
      await localServiceHive.user.putSecure(
        key: LocalKey.clientData,
        data: jsonString,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getClientData() async {
    try {
      String? value = await localServiceHive.user.getSecure(
        key: LocalKey.clientData,
      );
      if (value != null) {
        Map<String, dynamic> formatMap = jsonDecode(value);
        return formatMap;
      } else {
        return null;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[getClientData] error: $e");
      return null;
    }
  }
}
