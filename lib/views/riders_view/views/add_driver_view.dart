import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viewer/helpers/validator.dart';
import 'package:viewer/utils/app_theme.dart';

import '../../../controllers/drivers_controller.dart';
import '../components/drivers_info_input_box.dart';
import '../components/image_widget.dart';

class AddNewDriver extends GetResponsiveView<DriversController> {
  AddNewDriver({Key? key}) : super(key: key) {
    Get.lazyPut(() => DriversController());
  }

  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<File?> image = ValueNotifier<File?>(null);

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                    valueListenable: image,
                    builder: (context, value, child) {
                      return ImageWidget(
                        press: () async {
                          image.value = await controller.getCaptureImageSheet();
                        },
                        imageFile: image.value,
                      );
                    }),
                DriversInfoInputBox(
                  hintText: 'Driver\'s Username',
                  validator: Validator.nameValidator,
                  controller: _username,
                  icon: Icons.person,
                ),
                DriversInfoInputBox(
                  hintText: 'Driver\'s Password',
                  validator: Validator.passwordValidator,
                  controller: _password,
                  icon: Icons.person,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: Get.width * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          await controller.create(
                            username: _username.text,
                            password: _password.text,
                            image: image.value!,
                          );
                        }
                      },
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "Create",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: AppTheme.white,
                                letterSpacing: 5,
                                wordSpacing: 3,
                                fontSize: 15,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
