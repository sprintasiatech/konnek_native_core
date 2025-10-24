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
  Orientation? lastOrientation;

  void setInitialPosition() {
    final RenderBox? renderBox = _floatingKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && screenSize != null) {
      final newSize = renderBox.size;
      floatingWidgetSize = newSize;

      if (!userDragged) {
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

  void handleOrientationChange(Orientation currentOrientation) {
    if (lastOrientation != null && lastOrientation != currentOrientation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && screenSize != null) {
          setState(() {
            double newX = position.dx;
            double newY = position.dy;

            if (position.dx + floatingWidgetSize.width > screenSize!.width || position.dy + floatingWidgetSize.height > screenSize!.height) {
              newX = screenSize!.width - floatingWidgetSize.width - 15;
              newY = screenSize!.height - floatingWidgetSize.height - 55;
              userDragged = false;
            } else {
              newX = newX.clamp(0.0, screenSize!.width - floatingWidgetSize.width);
              newY = newY.clamp(0.0, screenSize!.height - floatingWidgetSize.height);
            }

            position = Offset(newX, newY);
          });
        }
      });
    }
    lastOrientation = currentOrientation;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenSize = MediaQuery.of(context).size;
      lastOrientation = MediaQuery.of(context).orientation;
      setInitialPosition();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentOrientation = MediaQuery.of(context).orientation;
    handleOrientationChange(currentOrientation);

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
