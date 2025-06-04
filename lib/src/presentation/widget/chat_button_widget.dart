import 'package:flutter/material.dart';
import 'package:konnek_native_core/src/presentation/controller/app_controller.dart';
import 'package:konnek_native_core/src/presentation/screen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatButtonWidget extends StatefulWidget {
  final Widget? customFloatingWidget;

  const ChatButtonWidget({
    super.key,
    this.customFloatingWidget,
  });

  @override
  State<ChatButtonWidget> createState() => _ChatButtonWidgetState();
}

class _ChatButtonWidgetState extends State<ChatButtonWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppController().getConfig(
        onSuccess: () {
          setState(() {});
        },
        onFailed: (errorMessage) {
          setState(() {});
        },
      );
    });
  }

  Widget handlerWidget() {
    Widget filledWidget = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: (AppController.iconWidget == null || AppController.floatingText == "") ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
      children: [
        (AppController.iconWidget != null && AppController.dataGetConfigValue?.iosIcon != "")
            ? Image.memory(
                AppController.iconWidget!,
                width: 50,
                fit: BoxFit.cover,
              )
            : SizedBox(),
        SizedBox(width: 10),
        Text(
          (AppController.floatingText != "") ? AppController.floatingText : "",
          // "talk to us",
          style: GoogleFonts.inter(
            color: AppController.floatingTextColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );

    Widget emptyWidget = RichText(
      text: TextSpan(
        text: "App! ",
        style: GoogleFonts.inter(
          color: Colors.green,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        children: <TextSpan>[
          TextSpan(
            // text: "      ",
            text: "Talk To Us",
            style: GoogleFonts.inter(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
    if (AppController.iconWidget == null && AppController.floatingText == "") {
      return emptyWidget;
    } else if (AppController.iconWidget != null) {
      return filledWidget;
    } else if (AppController.floatingText != "") {
      return filledWidget;
    } else {
      return filledWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen(
                callback: () {
                  setState(() {});
                },
              );
            },
          ),
        );
      },
      child: widget.customFloatingWidget ??
          Container(
            padding: EdgeInsets.all(16),
            width: 195,
            height: 70,
            decoration: BoxDecoration(
              color: AppController.floatingButtonColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: handlerWidget(),
          ),
    );
  }
}
