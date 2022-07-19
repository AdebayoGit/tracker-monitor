import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class ProgressDialog extends StatelessWidget {

  final  String status;
  const ProgressDialog({required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const FittedBox(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  )
              ),
              Text(status, style: const TextStyle(fontSize: 15),),
            ],
          ),
        ),
      ),
    );
  }
}