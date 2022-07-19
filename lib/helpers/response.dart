import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/progress_dialog.dart';
import '../utils/app_theme.dart';

class ResponseHelpers{
  static void showSnackbar(String message){
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      messageText: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: AppTheme.primaryColor,
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(color: AppTheme.nearlyWhite),
            letterSpacing: 1,
          ),
        ),
      ),
    ));
  }

  static void showProgressDialog(String message){
    Get.dialog(
        ProgressDialog(status: message),
        barrierDismissible: false,
    );
  }
}