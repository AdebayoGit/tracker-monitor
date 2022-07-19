import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../comments_dialog.dart';

class ControlWidget extends StatelessWidget {
  const ControlWidget({Key? key, required this.title, required this.subtitle, required this.body, required this.press, required this.action, required this.icon}) : super(key: key);

  final String action;
  final String title;
  final String subtitle;
  final String body;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: Get.width * 0.05,
            right: Get.width * 0.3,
            top: Get.height * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              FittedBox(
                child: Text(
                  subtitle,
                  style: GoogleFonts.abel(
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black)),
                ),
              ),
              Text(
                body,
                textAlign: TextAlign.justify,
                style: GoogleFonts.abel(
                    textStyle: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.black)),
              ),
            ],
          ),
        ),
        Center(
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return TripRemarksDialog();
                },
              );
            },
            iconSize: 100,
            constraints: BoxConstraints(
              minHeight: Get.height * 0.3,
              minWidth: Get.width * 0.5,
            ),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                FittedBox(
                  child: Text(
                    action,
                    style: GoogleFonts.dancingScript(
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
