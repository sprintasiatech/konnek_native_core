import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImageWidget extends StatefulWidget {
  final String image;
  final Future<bool> Function(DismissDirection) confirmDismiss;

  const ShowImageWidget({
    super.key,
    required this.image,
    required this.confirmDismiss,
  });

  @override
  State<ShowImageWidget> createState() => _ShowImageWidgetState();
}

class _ShowImageWidgetState extends State<ShowImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("value"),
      direction: DismissDirection.vertical,
      confirmDismiss: widget.confirmDismiss,
      onDismissed: (direction) {
        debugPrint("direction $direction");
      },
      child: PhotoView(
        // imageProvider: AssetImage(widget.image),
        imageProvider: NetworkImage(widget.image),
        maxScale: 2.5,
        backgroundDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
