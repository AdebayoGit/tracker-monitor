import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viewer/services/image_services.dart';

import '../utils/app_theme.dart';

class CaptureImageSheet extends StatelessWidget {
  final ValueChanged<File?> onChanged;

  CaptureImageSheet({required this.onChanged, Key? key}) : super(key: key);

  final ImageServices _services = ImageServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.05),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.contacts, color: AppTheme.nearlyWhite),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                child: Text(
                  "Capture Driver's image",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lato(
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: AppTheme.nearlyWhite, fontWeight: FontWeight.bold)),
                ),
              ),
              Text(
                "Select where you would like to get image from ?",
                textAlign: TextAlign.justify,
                style: GoogleFonts.abel(
                    textStyle: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: AppTheme.nearlyWhite)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      File? image = await _services.captureImage(source: _services.camera);
                      onChanged(image);
                    },
                    child: const Text(
                      'Camera',
                      style: TextStyle(
                        color: AppTheme.nearlyWhite,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      File? image = await _services.captureImage(source: _services.gallery);
                      onChanged(image);
                    },
                    child: const Text(
                      'Gallery',
                      style: TextStyle(
                        color: AppTheme.nearlyWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
