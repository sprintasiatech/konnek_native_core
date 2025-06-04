import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:konnek_native_core/inter_module.dart';
import 'package:konnek_native_core/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_native_core/src/env.dart';
import 'package:konnek_native_core/src/presentation/controller/app_controller.dart';
import 'package:konnek_native_core/src/support/app_logger.dart';

class BridgeMethodChannel {
  static const MethodChannel _channel = MethodChannel('konnek_native');

  static Future<void> clientConfigChannel(String data) async {
    Map<String, dynamic> mapping = jsonDecode(data);
    InterModule.clientId = mapping['clientId'];
    InterModule.clientSecret = mapping['clientSecret'];
    mapping['flavor'];
    if (mapping['flavor'] == "development") {
      EnvironmentConfig.flavor = Flavor.development;
    } else if (mapping['flavor'] == "staging") {
      EnvironmentConfig.flavor = Flavor.staging;
    } else if (mapping['flavor'] == "production") {
      EnvironmentConfig.flavor = Flavor.production;
    } else {
      EnvironmentConfig.flavor = Flavor.staging;
    }
    // You can trigger a UI update or logic here
  }

  // Optionally, handle calls from native
  static void setupHandler() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'clientConfigChannel') {
        final String data = call.arguments;
        clientConfigChannel(data);
      }
      if (call.method == 'fetchConfigData') {
        final String data = call.arguments;
        GetConfigResponseModel dataMap = GetConfigResponseModel.fromJson(jsonDecode(data));
        // InterModule.setupConfig(dataMap.dataGetConfigValue!);
        await AppController().getConfigFromNative(
          dataInput: dataMap.data!,
          onSuccess: (output) {
            InterModule.triggerUI.call();
          },
        );
      }
    });
  }

  static Future<String?> disposeEngine() async {
    try {
      final version = await _channel.invokeMethod<String>(
        'disposeEngine',
      );
      return version;
    } catch (e) {
      AppLoggerCS.debugLog("[BridgeMethodChannel][disposeEngine] error $e");
      return null;
    }
  }
}
