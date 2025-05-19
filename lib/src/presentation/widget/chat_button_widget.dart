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
            decoration: BoxDecoration(
              color: AppController.floatingButtonColor,
              // color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: AppController.iconWidget != null
                // child: AppController.iconWidget.value != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.memory(
                        AppController.iconWidget!,
                        // AppController.iconWidget.value!,
                        // height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Text(
                        AppController.floatingText,
                        // "talk to us",
                        style: GoogleFonts.inter(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  )
                : RichText(
                    text: TextSpan(
                      text: "App! ",
                      style: GoogleFonts.inter(
                        color: Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Talk To Us",
                          style: GoogleFonts.inter(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
            // child: Text(
            //   "App! Talk To Us",
            //   style: GoogleFonts.inter(
            //     color: Colors.green,
            //     fontSize: 28,
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),
          ),
    );
  }
}
