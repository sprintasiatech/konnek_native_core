import 'package:flutter/material.dart';
import 'package:konnek_native_core/bridge_method_channel.dart';
import 'package:konnek_native_core/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_native_core/src/env.dart';
import 'package:konnek_native_core/src/support/app_api_service.dart';
import 'package:konnek_native_core/src/support/app_connectivity_service.dart';
import 'package:konnek_native_core/src/support/app_device_info.dart';
import 'package:konnek_native_core/src/support/app_info.dart';
import 'package:konnek_native_core/src/support/app_logger.dart';
import 'package:konnek_native_core/src/support/local_service_hive.dart';

class InterModule {
  static String clientId = "";
  static String clientSecret = "";
  static String accessToken = "";

  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  static AppConnectivityServiceCS appConnectivityServiceCS = AppConnectivityServiceCS();
  static AppDeviceInfoCS appDeviceInfo = AppDeviceInfoCS();
  static AppInfoCS appInfoCS = AppInfoCS();
  static LocalServiceHive localServiceHive = LocalServiceHive();

  static void Function(DataGetConfig data) setupConfig = (DataGetConfig data) {};
  static void Function() triggerUI = () {};

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    EnvironmentConfig.flavor = Flavor.staging;
    AppLoggerCS.useLogger = true;
    AppLoggerCS.useFoundation = true;
    //
    appApiService.useFoundation = true;
    appApiService.useLogger = true;
    //
    await localServiceHive.init();
    await appInfoCS.init();
    await appConnectivityServiceCS.init();
    await appDeviceInfo.getDeviceData();

    BridgeMethodChannel.setupHandler();

    setupConfig = (dataConfig) {
      AppLoggerCS.debugLog("[InterModule][initialize][setupConfig] called");
    };
  }
}
