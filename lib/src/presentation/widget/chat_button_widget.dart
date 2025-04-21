import 'package:flutter/material.dart';
import 'package:flutter_module1/src/presentation/screen/login_screen.dart';
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
              return const LoginScreen();
            },
          ),
        );
      },
      child: widget.customFloatingWidget ??
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: RichText(
              text: TextSpan(
                text: "App! ",
                style: GoogleFonts.inter(
                  color: Colors.green,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Talk To Us",
                    style: GoogleFonts.inter(
                      color: Colors.green,
                      fontSize: 20,
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
