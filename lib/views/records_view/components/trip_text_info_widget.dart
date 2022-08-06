import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_theme.dart';

class TextInfo extends StatelessWidget {
  const TextInfo({Key? key, required this.label, required this.text}) : super(key: key);

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: SizedBox(
              width: Get.width * 0.3,
              child: Text(
                '$label:',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(
                    color: AppTheme.primaryDarkColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: SizedBox(
              width: Get.width * 0.6,
              child: Text(
                text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
