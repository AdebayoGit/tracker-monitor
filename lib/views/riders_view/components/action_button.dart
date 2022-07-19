import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viewer/utils/app_theme.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {required this.icon,
      required this.label,
      required this.body,
      required this.press,
      required this.buttonColor,
      required this.textColor,
      Key? key})
      : super(key: key);

  final Icon icon;
  final Color buttonColor;
  final Color textColor;
  final String label;
  final String body;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        shadowColor: Colors.grey,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onPressed: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
              color: AppTheme.primaryLightColor,
              shape: BoxShape.circle,
            ),
            child: icon,
          ),
          FittedBox(
            child: Text(
              label,
              style: AppTheme.title,
              maxLines: 2,
            ),
          ),
          Flexible(
            child: Text(
              body,
              overflow: TextOverflow.visible,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
