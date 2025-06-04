import 'package:flutter/material.dart';
import 'package:konnek_native_core/app.dart';
import 'package:konnek_native_core/inter_module.dart';

void main() async {
  runApp(const MyApp());
  await InterModule().initialize();
}
