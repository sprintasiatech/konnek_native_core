import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module1/src/env.dart';
import 'package:flutter_module1/src/presentation/interface/live_chat_sdk_platform.dart';

import '../widget/chat_button_widget.dart';
// import 'package:flutter_module1/widget/chat_button_widget.dart';

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
