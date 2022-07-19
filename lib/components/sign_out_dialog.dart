import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:viewer/controllers/auth_controller.dart';

import '../utils/app_theme.dart';


class SignOutDialog extends GetResponsiveView<AuthController> {
  SignOutDialog({required this.yes, required this.no, Key? key}) : super(key: key){
    Get.lazyPut(() => AuthController());
  }

  final VoidCallback yes;
  final VoidCallback no;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                "assets/icons/log_out.svg",
                color: AppTheme.primaryColor,
                width: 22,
              ),
              const SizedBox(width: 20),
              const Expanded(child: Text('Sign Out')),
            ],
          ),
          const Divider(
            thickness: 2.5,
          ),
        ],
      ),
      content:
      const Text('Are you sure you wish to Sign Out ?'),
      actions: <Widget>[
        TextButton(
          onPressed: yes,
          child: const Text(
            'Yes',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: no,
          child: const Text(
            'No',
            style: TextStyle(
              color: AppTheme.colorGreen,
            ),
          ),
        ),
      ],
    );
  }
}
