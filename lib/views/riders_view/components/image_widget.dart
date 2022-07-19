import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_theme.dart';



class ImageWidget extends StatelessWidget {
  const ImageWidget({required this.imageFile, Key? key, required this.press}) : super(key: key);


  final File? imageFile;
  final VoidCallback press;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        height: Get.height * 0.15,
        width: Get.height * 0.15,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryColor,
          ),
        ),
        child: imageFile != null ? Padding(
          padding: EdgeInsets.all(Get.height * 0.003),
          child: Image.file(
            imageFile!,
            height: Get.height * 0.08,
            width: Get.height * 0.08,
            fit: BoxFit.fill,
            frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 5),
                curve: Curves.easeOut,
                child: child,
              );
            },
          ),
        ) : Padding(
          padding: EdgeInsets.all(Get.height * 0.01),
          child: Material(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            child: const Icon(Icons.add_a_photo, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
