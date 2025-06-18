import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konnek_native_core/assets/assets.dart';
import 'package:konnek_native_core/bridge_method_channel.dart';
import 'package:konnek_native_core/inter_module.dart';
import 'package:konnek_native_core/src/data/source/local/chat_local_source.dart';
import 'package:konnek_native_core/src/presentation/controller/app_controller.dart';
import 'package:konnek_native_core/src/presentation/screen/chat_screen.dart';
import 'package:konnek_native_core/src/support/string_extension.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? callback;

  const LoginScreen({
    super.key,
    this.callback,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      InterModule.triggerUI = () {
        setState(() {});
      };
    });
  }

  String nameErrorText = "";
  void _validateName(String name) {
    if (name.isEmpty) {
      setState(() => nameErrorText = 'Name is required');
    } else if (!name.isValidName) {
      setState(() => nameErrorText = 'Enter a valid name');
    } else {
      setState(() => nameErrorText = "");
    }
  }

  String errorText = "";
  void _validateEmail(String email) {
    if (email.isEmpty) {
      setState(() => errorText = 'Email is required');
    } else if (!email.isValidEmail) {
      setState(() => errorText = 'Enter a valid email');
    } else if (!email.isAllLowercaseEmail) {
      setState(() => errorText = 'Only lowercase accepted');
    } else {
      setState(() => errorText = "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        nameController.clear();
        emailController.clear();
        // 
        BridgeMethodChannel.disposeEngine();
        SystemNavigator.pop(animated: true);
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () {
                nameController.clear();
                emailController.clear();
                // 
                BridgeMethodChannel.disposeEngine();
                SystemNavigator.pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Center(
                    // child: (AppController.dataGetConfigValue != null)
                    //     ? Image.memory(
                    //         Uri.parse(AppController.dataGetConfigValue!.avatarImage!).data!.contentAsBytes(),
                    //         // base64Decode(dataGetConfig!.avatarImage!),
                    //         height: 100,
                    //         width: 100,
                    //         fit: BoxFit.cover,
                    //       )
                    //     : Text(
                    //         // "App!",
                    //         (AppController.dataGetConfigValue != null) ? "${AppController.dataGetConfigValue?.avatarName}" : "Cust Service",
                    //         textAlign: TextAlign.center,
                    //         style: GoogleFonts.lato(
                    //           fontSize: 34,
                    //           fontWeight: FontWeight.w700,
                    //         ),
                    //       ),
                    child: (AppController.dataGetConfigValue != null)
                        ? Text(
                            (AppController.dataGetConfigValue != null) ? "${AppController.dataGetConfigValue?.avatarName}" : "Cust Service",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(
                            "App!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                    // child: Text(
                    //   "App!",
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.lato(
                    //     fontSize: 34,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                  ),
                  SizedBox(height: 80),
                  Text(
                    "Name",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    child: TextField(
                      onChanged: (value) {
                        _validateName(value);
                      },
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Your name",
                        hintStyle: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (nameErrorText != "")
                    Text(
                      nameErrorText,
                      style: GoogleFonts.lato(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: 15),
                  Text(
                    "Email",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _validateEmail(value);
                      },
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Your email",
                        hintStyle: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (errorText != "")
                    Text(
                      errorText,
                      style: GoogleFonts.lato(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
                              // color: Colors.lightBlue.shade100.withValues(alpha: 0.5),
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
                      onTap: () async {
                        if (errorText != "" || nameErrorText != "") {
                          //
                        } else if (nameController.text.isEmpty || emailController.text.isEmpty) {
                          errorText = "email field is empty";
                          nameErrorText = "name field is empty";
                        } else {
                          errorText = "";
                          nameErrorText = "";
                          await AppController()
                              .loadData(
                            name: nameController.text,
                            email: emailController.text,
                          )
                              .then((value) {
                            AppController.open();
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChatScreen();
                                },
                              ),
                            );
                          });

                          await ChatLocalSource().getClientData();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Powered By",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 5),
                        Image.asset(
                          Assets.icKonnek,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
