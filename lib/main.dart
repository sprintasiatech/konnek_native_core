import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:konnek_native_core/app.dart';
import 'package:konnek_native_core/inter_module.dart';

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log("[main][FlutterError.onError]: $details");
    debugPrint("[main][FlutterError.onError]: $details");
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    log("[main][FlutterError.onError] error: $error");
    debugPrint("[main][FlutterError.onError] error: $error");
    log("[main][FlutterError.onError] stack: $stack");
    debugPrint("[main][FlutterError.onError] stack: $stack");
    return true;
  };
  runApp(const MyApp());
  await InterModule().initialize();
}
