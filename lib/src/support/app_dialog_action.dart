import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konnek_native_core/assets/assets.dart';
import 'package:konnek_native_core/src/support/app_mainbutton_widget.dart';

class AppDialogActionCS {
  static Future<void> showSuccessSignUp({
    required BuildContext context,
    required Function() mainButtonAction,
    double radius = 0,
    String title = "",
    String buttonTitle = "Tutup",
    Color? color,
    bool barrierDismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) async {
    return await showPopup(
      context: context,
      radius: radius,
      color: color,
      content: Column(
        children: [
          Row(
            children: [
              (barrierDismissible)
                  ? InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: const Color(0xff26120F),
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(width: 20),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xff26120F),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          // Image.asset(
          //   Assets.successSignUp,
          //   height: 150,
          // ),
          Icon(
            Icons.check,
            size: 150,
          ),
          SizedBox(height: 31),
          Text(
            "Sign Up Success",
            style: GoogleFonts.inter(
              color: const Color(0xff26120F),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24),
          AppMainButtonWidget(
            onPressed: mainButtonAction,
            text: buttonTitle,
            fontSize: 14,
            height: 40,
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
      padding: padding,
    );
  }

  static Future<void> showMainPopup({
    required BuildContext context,
    Function()? mainButtonAction,
    Function()? secondaryButtonAction,
    double radius = 0,
    String title = "",
    String? buttonTitle,
    String? secondaryButtonTitle,
    Color? mainButtonColor,
    Color? secondaryButtonColor,
    Color? color,
    Widget? content,
    bool barrierDismissible = true,
    bool useButtonBack = true,
    bool reverseButton = false,
    bool isHorizontal = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double? buttonHeight,
    double? buttonTextSize,
    void Function(bool isOpen)? isDialogOpen,
  }) async {
    Color defaultSecondaryButtonColor = Colors.red;
    // Color defaultSecondaryButtonColor = Colors.grey.shade700;
    isDialogOpen?.call(true);
    await showPopup(
      context: context,
      radius: radius,
      color: color,
      content: Column(
        children: [
          Row(
            children: [
              barrierDismissible
                  ? useButtonBack
                      ? InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: const Color(0xff26120F),
                            ),
                          ),
                        )
                      : const SizedBox()
                  : const SizedBox(),
              SizedBox(width: 20),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xff26120F),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          content ?? const SizedBox(),
          SizedBox(height: 24),
          (isHorizontal)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: reverseButton
                      ? [
                          if (secondaryButtonTitle != null)
                            AppMainButtonWidget(
                              onPressed: secondaryButtonAction,
                              text: secondaryButtonTitle,
                              fontSize: buttonTextSize ?? 18,
                              height: buttonHeight ?? 48,
                              color: secondaryButtonColor ?? defaultSecondaryButtonColor,
                            ),
                          if (buttonTitle != null && secondaryButtonTitle != null) SizedBox(height: 8),
                          if (buttonTitle != null)
                            AppMainButtonWidget(
                              onPressed: mainButtonAction,
                              text: buttonTitle,
                              fontSize: buttonTextSize ?? 18,
                              height: buttonHeight ?? 48,
                              color: mainButtonColor,
                            ),
                        ]
                      : [
                          if (buttonTitle != null)
                            AppMainButtonWidget(
                              onPressed: mainButtonAction,
                              text: buttonTitle,
                              fontSize: buttonTextSize ?? 18,
                              height: buttonHeight ?? 48,
                              color: mainButtonColor,
                            ),
                          if (buttonTitle != null && secondaryButtonTitle != null) SizedBox(height: 8),
                          if (secondaryButtonTitle != null)
                            AppMainButtonWidget(
                              onPressed: secondaryButtonAction,
                              text: secondaryButtonTitle,
                              fontSize: buttonTextSize ?? 18,
                              height: buttonHeight ?? 48,
                              color: secondaryButtonColor ?? defaultSecondaryButtonColor,
                            ),
                        ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: reverseButton
                      ? [
                          if (secondaryButtonTitle != null)
                            Expanded(
                              child: AppMainButtonWidget(
                                onPressed: secondaryButtonAction,
                                text: secondaryButtonTitle,
                                fontSize: buttonTextSize ?? 18,
                                height: buttonHeight ?? 48,
                                color: secondaryButtonColor ?? defaultSecondaryButtonColor,
                              ),
                            ),
                          if (buttonTitle != null && secondaryButtonTitle != null) SizedBox(width: 12),
                          if (buttonTitle != null)
                            Expanded(
                              child: AppMainButtonWidget(
                                onPressed: mainButtonAction,
                                text: buttonTitle,
                                fontSize: buttonTextSize ?? 18,
                                height: buttonHeight ?? 48,
                                color: mainButtonColor,
                              ),
                            ),
                        ]
                      : [
                          if (buttonTitle != null)
                            Expanded(
                              child: AppMainButtonWidget(
                                onPressed: mainButtonAction,
                                text: buttonTitle,
                                fontSize: buttonTextSize ?? 18,
                                height: buttonHeight ?? 48,
                                color: mainButtonColor,
                              ),
                            ),
                          if (buttonTitle != null && secondaryButtonTitle != null) SizedBox(width: 12),
                          if (secondaryButtonTitle != null)
                            Expanded(
                              child: AppMainButtonWidget(
                                onPressed: secondaryButtonAction,
                                text: secondaryButtonTitle,
                                fontSize: buttonTextSize ?? 18,
                                height: buttonHeight ?? 48,
                                color: secondaryButtonColor ?? defaultSecondaryButtonColor,
                              ),
                            ),
                        ],
                ),
        ],
      ),
      barrierDismissible: barrierDismissible,
      padding: padding,
    );
    isDialogOpen?.call(false);
  }

  static Future<void> showSecondaryPopup({
    required BuildContext context,
    double radius = 0,
    String title = "",
    String buttonTitle = "",
    Color? color,
    Widget? content,
    bool barrierDismissible = true,
    bool useButtonBack = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) async {
    return await showPopup(
      context: context,
      radius: radius,
      color: color,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xff26120F),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              useButtonBack
                  ? InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: const Color(0xff26120F),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          SizedBox(height: 24),
          content ?? const SizedBox(),
        ],
      ),
      barrierDismissible: barrierDismissible,
      padding: padding,
    );
  }

  static Future<void> showPopup({
    required BuildContext context,
    double radius = 0,
    Color? color,
    Widget? content,
    bool barrierDismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        // onWillPop: () => Future.value(barrierDismissible),
        // onWillPop: () async {
        //   return barrierDismissible;
        // },
        canPop: barrierDismissible,
        child: Center(
          child: SingleChildScrollView(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.all(30),
                padding: padding,
                // width: double.infinity,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: color ?? const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: content ?? const SizedBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showSuccessPopup({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonTitle,
    Function()? mainButtonAction,
    double radius = 10,
    double? buttonHeight,
    double? buttonTextSize,
    bool barrierDismissible = true,
  }) async {
    await showMainPopup(
      context: context,
      title: '',
      radius: radius,
      buttonHeight: buttonHeight,
      buttonTextSize: buttonTextSize,
      barrierDismissible: barrierDismissible,
      useButtonBack: false,
      content: Column(
        children: [
          Image.asset(
            Assets.iconPopupSuccess,
            package: "konnek_flutter",
            height: 96,
            width: 96,
          ),
          SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      buttonTitle: buttonTitle,
      mainButtonAction: mainButtonAction ??
          () {
            if (barrierDismissible) {
              Navigator.pop(context);
            }
          },
    );
  }

  static Future<void> showFailedPopup({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonTitle,
    required Function() mainButtonAction,
    double radius = 10,
    double? buttonHeight,
    double? buttonTextSize,
    bool barrierDismissible = true,
  }) async {
    await showMainPopup(
      context: context,
      title: '',
      radius: radius,
      buttonHeight: buttonHeight,
      buttonTextSize: buttonTextSize,
      barrierDismissible: barrierDismissible,
      useButtonBack: false,
      content: Column(
        children: [
          Image.asset(
            Assets.iconPopupError,
            package: "konnek_flutter",
            height: 96,
            width: 96,
          ),
          SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      buttonTitle: buttonTitle,
      // mainButtonAction: mainButtonAction ??
      //     () {
      //       if (barrierDismissible) {
      //         Navigator.pop(context);
      //       }
      //     },
      // mainButtonAction: mainButtonAction ?? () {},
      mainButtonAction: mainButtonAction,
    );
  }

  static Future<void> showWarningPopup({
    required BuildContext context,
    required String title,
    required String description,
    String? mainButtonTitle,
    String? secondaryButtonTitle,
    Function()? mainButtonAction,
    Function()? secondaryButtonAction,
    Color? mainButtonColor,
    Color? secondaryButtonColor,
    double radius = 10,
    double? buttonHeight,
    double? buttonTextSize,
    bool barrierDismissible = true,
    bool reverseButton = false,
    bool isHorizontal = true,
  }) async {
    await showMainPopup(
      context: context,
      title: '',
      radius: radius,
      buttonHeight: buttonHeight,
      buttonTextSize: buttonTextSize,
      barrierDismissible: barrierDismissible,
      useButtonBack: false,
      reverseButton: reverseButton,
      isHorizontal: isHorizontal,
      content: Column(
        children: [
          Image.asset(
            Assets.iconPopupWarning,
            package: "konnek_flutter",
            height: 96,
            width: 96,
          ),
          SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      buttonTitle: mainButtonTitle,
      secondaryButtonTitle: secondaryButtonTitle,
      mainButtonColor: mainButtonColor,
      secondaryButtonColor: secondaryButtonColor,
      mainButtonAction: mainButtonAction ??
          () {
            if (barrierDismissible) {
              Navigator.pop(context);
            }
          },
      secondaryButtonAction: secondaryButtonAction ??
          () {
            //
          },
    );
  }
}
