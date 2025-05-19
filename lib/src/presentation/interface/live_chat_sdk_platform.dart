import 'package:flutter/material.dart';
import 'package:konnek_native_core/src/presentation/interface/live_chat_sdk_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class LiveChatSDKPlatform extends PlatformInterface {
  LiveChatSDKPlatform() : super(token: _token);

  static final Object _token = Object();

  static LiveChatSDKPlatform _instance = LiveChatSdkChannel();

  static LiveChatSDKPlatform get instance => _instance;

  static set instance(LiveChatSDKPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Widget entryPoint({
    Widget? customFloatingWidget,
  }) {
    throw UnimplementedError("entryPointWidget() has not been implemented");
  }

  Future<void> initialize() async {
    throw UnimplementedError("initialize() has not been implemented");
  }
}
