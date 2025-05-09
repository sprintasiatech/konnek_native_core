import 'dart:convert';
import 'dart:developer';

import 'package:fam_coding_supply/logic/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module1/inter_module.dart';
import 'package:flutter_module1/src/env.dart';

class BridgeMethodChannel {
  static const MethodChannel _channel = MethodChannel('konnek_native');
  // static String clientId = "";
  // static String clientSecret = "";

  static Future<void> clientConfigChannel(String data) async {
    AppLoggerCS.debugLog('[BridgeMethodChannel][AppLoggerCS.debugLog] Data received from native 1: $data');
    AppLoggerCS.debugLog('[BridgeMethodChannel][AppLoggerCS.debugLog] Data received from native 2: ${jsonEncode(data)}');

    log('[BridgeMethodChannel][log developer] Data received from native 1: $data');
    log('[BridgeMethodChannel][log developer] Data received from native 2: ${jsonEncode(data)}');

    debugPrint('[BridgeMethodChannel][debugPrint foundation] Data received from native 1: $data');
    debugPrint('[BridgeMethodChannel][debugPrint foundation] Data received from native 2: ${jsonEncode(data)}');

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
    });
  }
}
