import 'package:flutter/material.dart';

import 'package:konnek_native_core/src/presentation/interface/live_chat_sdk.dart';

class LiveChatSdkScreen extends StatefulWidget {
  final Widget child;
  final Widget? customFloatingWidget;

  const LiveChatSdkScreen({
    super.key,
    required this.child,
  }) : customFloatingWidget = null;

  const LiveChatSdkScreen.customFloatingWidget({
    super.key,
    required this.child,
    required this.customFloatingWidget,
  });

  @override
  State<LiveChatSdkScreen> createState() => _LiveChatSdkScreenState();
}

class _LiveChatSdkScreenState extends State<LiveChatSdkScreen> {
  Offset position = const Offset(0, 0); // Initial dummy offset; will be set properly post-build
  Size? screenSize;
  Size floatingWidgetSize = Size.zero; // To store measured size
  final GlobalKey _floatingKey = GlobalKey(); // Key to measure the floating widget

  final LiveChatSdk liveChatSdk = LiveChatSdk();

  void setInitialPosition() {
    final RenderBox? renderBox = _floatingKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && screenSize != null) {
      floatingWidgetSize = renderBox.size;
      position = Offset(
        screenSize!.width - floatingWidgetSize.width - 15,
        screenSize!.height - floatingWidgetSize.height - 15,
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenSize = MediaQuery.of(context).size;
      setInitialPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          Positioned(
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  position += details.delta;
                  position = Offset(
                    position.dx.clamp(0.0, (screenSize?.width ?? 0) - floatingWidgetSize.width),
                    position.dy.clamp(0.0, (screenSize?.height ?? 0) - floatingWidgetSize.height),
                  );
                });
              },
              child: Container(
                key: _floatingKey, 
                child: liveChatSdk.entryPointWidget(
                  customFloatingWidget: widget.customFloatingWidget,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}