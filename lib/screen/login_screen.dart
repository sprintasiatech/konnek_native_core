import 'package:flutter/material.dart';
import 'package:flutter_module1/screen/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Center(
                child: Text(
                  "App!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 80),
              Text("Email/Phone number"),
              SizedBox(height: 8),
              SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text("Password"),
              SizedBox(height: 8),
              SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 2),
                          color: Colors.lightBlue.shade100.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Start Chat!",
                        style: GoogleFonts.lato(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatScreen();
                        },
                      ),
                    );
                  },
                ),
                // child: ElevatedButton(
                //   onPressed: () {
                //     //
                //   },
                //   style: ElevatedButton.styleFrom(),
                //   child: Text(
                //     "Start Chat!",
                //     style: GoogleFonts.lato(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                // ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  "Powered By Konnek!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
