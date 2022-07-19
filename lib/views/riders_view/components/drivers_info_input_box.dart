import 'package:flutter/material.dart';
import 'package:viewer/utils/app_theme.dart';

import 'input_container.dart';

class DriversInfoInputBox extends StatelessWidget {
  const DriversInfoInputBox({Key? key, required this.controller, this.validator, required this.hintText, required this.icon}) : super(key: key);

  final TextEditingController controller;
  final dynamic validator;
  final String hintText;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return InputFieldContainer(
      child: TextFormField(
          controller: controller,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: AppTheme.secondaryColor,
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.secondaryColor)),
            focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.colorOrange)),
            prefixIcon: Icon(
              icon,
              color: AppTheme.primaryColor,
            ),
            hintText: hintText,
          )
      ),
    );
  }
}
