import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewer/controllers/auth_controller.dart';

import '../helpers/validator.dart';
import '../utils/app_theme.dart';

class ForgotPasswordSheet extends GetResponsiveView<AuthController> {
  ForgotPasswordSheet({Key? key}) : super(key: key){
    Get.lazyPut(() => AuthController());
  }

  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            child: Image.asset('./assets/images/trucks.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              controller: _email,
              keyboardType: TextInputType.text,
              validator: Validator.emailValidator,
              decoration: InputDecoration(
                label: Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.grey[900],
                  ),
                ),
                hintText: 'test@test.com',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey[900],
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[900]!)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: (){
                controller.forgotPassword(email: _email.text);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                maximumSize: Size(Get.width * 0.8, 50),
                primary: Colors.grey[900],
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: const SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                      color: AppTheme.nearlyWhite,
                      fontSize: 20,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
