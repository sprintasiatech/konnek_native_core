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
  Offset position = const Offset(0, 0);
  Size? screenSize;
  Size floatingWidgetSize = Size.zero;
  final GlobalKey _floatingKey = GlobalKey();

  final LiveChatSdk liveChatSdk = LiveChatSdk();

  bool userDragged = false;

  void setInitialPosition() {
    final RenderBox? renderBox = _floatingKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && screenSize != null) {
      final newSize = renderBox.size;

      if (!userDragged) {
        floatingWidgetSize = newSize;
        final newPosition = Offset(
          screenSize!.width - floatingWidgetSize.width - 15,
          screenSize!.height - floatingWidgetSize.height - 55,
        );

        if (position != newPosition) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !userDragged) {
              setState(() {
                position = newPosition;
              });
            }
          });
        }
      }
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenSize = MediaQuery.of(context).size;
      setInitialPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          screenSize = Size(constraints.maxWidth, constraints.maxHeight);

          return Stack(
            children: [
              widget.child,
              Positioned(
                left: position.dx,
                top: position.dy,
                child: _buildFloatingWidget(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFloatingWidget() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          userDragged = true;
          position += details.delta;
          position = Offset(
            position.dx.clamp(0.0, (screenSize?.width ?? 0) - floatingWidgetSize.width),
            position.dy.clamp(0.0, (screenSize?.height ?? 0) - floatingWidgetSize.height),
          );
        });
      },
      child: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (_) {
          setInitialPosition();
          return true;
        },
        child: SizeChangedLayoutNotifier(
          child: Container(
            key: _floatingKey,
            child: liveChatSdk.entryPointWidget(
              customFloatingWidget: widget.customFloatingWidget,
            ),
          ),
        ),
      ),
    );
  }
}
