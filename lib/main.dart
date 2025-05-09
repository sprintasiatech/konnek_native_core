import 'package:flutter/material.dart';
import 'package:flutter_module1/app.dart';
import 'package:flutter_module1/bridge_method_channel.dart';
import 'package:flutter_module1/inter_module.dart';

void main() async {
  runApp(const MyApp());
  await InterModule().initialize(
    // inputClientId: 'b699182d-5ff0-4161-b649-239234ff9cb9',
    // inputClientSecret: '1dc8e065-2915-4b4e-8df2-45040e8314bd',
  );
}
