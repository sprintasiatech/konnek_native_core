import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:konnek_native_core/bridge_method_channel.dart';
import 'package:konnek_native_core/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_native_core/src/env.dart';

class InterModule {
  static String clientId = "";
  static String clientSecret = "";

  static String accessToken = "";

  static FamCodingSupply famCodingSupply = FamCodingSupply();
  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  static void Function(DataGetConfig data) setupConfig = (DataGetConfig data) {};
  static void Function() triggerUI = () {};

  Future<void> initialize(
      //   {
      //   required String inputClientId,
      //   required String inputClientSecret,
      //   dynamic configuration,
      // }
      ) async {
    // clientId = inputClientId;
    // clientSecret = inputClientSecret;
    BridgeMethodChannel.setupHandler();
    setupConfig = (dataConfig) {
      AppLoggerCS.debugLog("[InterModule][initialize][setupConfig] called");
      BridgeMethodChannel.configData(dataConfig.toJson());
    };

    EnvironmentConfig.flavor = Flavor.staging;
    // await LiveChatSdk().initialize();
    AppLoggerCS.useLogger = true;
    AppLoggerCS.useFoundation = true;
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
