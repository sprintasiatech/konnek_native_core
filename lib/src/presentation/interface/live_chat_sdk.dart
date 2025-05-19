import 'package:flutter/material.dart';
import 'package:konnek_native_core/src/presentation/interface/live_chat_sdk_platform.dart';

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
