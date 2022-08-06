import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_theme.dart';


class LocationTile extends StatelessWidget {
  const LocationTile({Key? key, required this.press, required this.title, required this.time, required this.remark, this.initiallyExpanded = false}) : super(key: key);

  final VoidCallback press;
  final String title;
  final String time;
  final String remark;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      leading: GestureDetector(
        onTap: press,
        child: const SizedBox(
          height: 45,
          width: 45,
          child: Card(
            shape: CircleBorder(
              side: BorderSide(
                  color: AppTheme.colorGreen, width: 2),
            ),
            color: AppTheme.primaryColor,
            shadowColor: AppTheme.primaryLightColor,
            elevation: 3,
            child: Icon(
              Icons.play_arrow,
              color: AppTheme.colorGreen,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        textScaleFactor: 0.7,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.lato(
          textStyle:
          Theme.of(context).textTheme.headline6!.copyWith(
            color: AppTheme.primaryDarkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(
        time,
        style: GoogleFonts.dancingScript(
          textStyle: TextStyle(
            color: Colors.yellow[900],
            //fontStyle: FontStyle.italic
          ),
        ),
      ),
      iconColor: AppTheme.colorGreen,
      collapsedIconColor: AppTheme.colorGreen,
      children: [
        Text(
          "\"$remark\"",
          maxLines: 5,
          textScaleFactor: 0.7,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lato(
            textStyle:
            Theme.of(context).textTheme.bodyText2!.copyWith(
              color: AppTheme.primaryColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
