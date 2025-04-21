import 'package:flutter/material.dart';
import 'package:flutter_module1/src/presentation/interface/live_chat_sdk_platform.dart';

class LiveChatSdk {
  Widget entryPointWidget({
    Widget? customFloatingWidget,
  }) {
    return LiveChatSDKPlatform.instance.entryPoint(
      customFloatingWidget: customFloatingWidget,
    );
  }

  Future<void> initialize() async {
    await LiveChatSDKPlatform.instance.initialize();
  }
}
