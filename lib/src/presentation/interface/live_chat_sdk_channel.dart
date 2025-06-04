
import 'package:flutter/material.dart';
import 'package:konnek_native_core/src/env.dart';
import 'package:konnek_native_core/src/presentation/interface/live_chat_sdk_platform.dart';
import 'package:konnek_native_core/src/support/local_service_hive.dart';

import '../widget/chat_button_widget.dart';
// import 'package:konnek_native_core/widget/chat_button_widget.dart';

class LiveChatSdkChannel extends LiveChatSDKPlatform {
  @override
  Widget entryPoint({
    Widget? customFloatingWidget,
  }) {
    return ChatButtonWidget(
      customFloatingWidget: customFloatingWidget,
    );
  }

  @override
  Future<void> initialize() async {
    EnvironmentConfig.flavor = Flavor.staging;
    LocalServiceHive().init();
  }
}
