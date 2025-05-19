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
  Offset position = Offset(70, -40);

  final LiveChatSdk liveChatSdk = LiveChatSdk();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your main UI here
          widget.child,

          // Draggable floating widget
          Align(
            alignment: Alignment.bottomCenter,
            // left: position.dx,
            // top: position.dy,
            child: Transform.translate(
              offset: position,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    position += details.delta;
                  });
                },
                // child: widget.draggableWidget,
                // child: widget.draggableWidget.entryPointWidget(),
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
