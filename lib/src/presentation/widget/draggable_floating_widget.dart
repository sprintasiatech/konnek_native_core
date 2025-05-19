import 'package:flutter/material.dart';
import 'package:konnek_native_core/src/presentation/interface/live_chat_sdk.dart';

/// Helper class to put your draggable floating top of your screen
class DraggableFloatingWidget extends StatefulWidget {
  /// Your main screen
  final Widget child;
  final Widget? customFloatingWidget;

  /// Put your mini widget here to be draggable and floating
  // final Widget draggableWidget;
  // final LiveChatSdk draggableWidget;

  const DraggableFloatingWidget({
    super.key,
    required this.child,
    //   required this.draggableWidget,
  }) : customFloatingWidget = null;

  const DraggableFloatingWidget.customFloatingWidget({
    super.key,
    required this.child,
    required this.customFloatingWidget,
    //   required this.draggableWidget,
  });

  @override
  State<DraggableFloatingWidget> createState() => _DraggableFloatingWidgetState();
}

class _DraggableFloatingWidgetState extends State<DraggableFloatingWidget> {
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
                // child: liveChatSdk.entryPointWidget(),
                child: widget.customFloatingWidget ?? liveChatSdk.entryPointWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
