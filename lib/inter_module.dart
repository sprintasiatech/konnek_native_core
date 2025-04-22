import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter_module1/src/env.dart';

class InterModule {
  static String clientId = "";
  static String clientSecret = "";

  static String accessToken = "";

  static FamCodingSupply famCodingSupply = FamCodingSupply();
  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  Future<void> initialize({
    required String inputClientId,
    required String inputClientSecret,
    dynamic configuration,
  }) async {
    clientId = inputClientId;
    clientSecret = inputClientSecret;

    EnvironmentConfig.flavor = Flavor.staging;
    // await LiveChatSdk().initialize();
    AppLoggerCS.useLogger = true;
    //
    appApiService.useFoundation = true;
    appApiService.useLogger = true;
    //
    await famCodingSupply.appInfo.init();
    await famCodingSupply.appConnectivityService.init();
    await famCodingSupply.appDeviceInfo.getDeviceData();
    await famCodingSupply.localServiceHive.init();
  }

  // Widget entryPointWidget() {
  //   return InterModulePlatform.instance.entryPointWidget();
  // }
}
