import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viewer/controllers/trips_controller.dart';

import '../../../utils/app_theme.dart';

class NameChange extends GetView<TripsController> {
  NameChange({required this.tripId, Key? key}) : super(key: key);

  final String tripId;

  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: Get.height * 0.03),
              child: Text(
                'Please enter a new name',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
            child: TextFormField(
              controller: _name,
              maxLines: 1,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                label: const Text('Name'),
                labelStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[900]!,
                ),
                hintText: 'Provide a new trip name',
                hintStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: Icon(Icons.edit_note, color: Colors.grey[900]!),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[900]!,
                  ),
                ),
                focusColor: Colors.grey,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  controller.renameTrip(tripId, _name.text);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  maximumSize: Size(Get.width * 0.7, 50),
                  primary: Colors.grey[900],
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Rename',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        letterSpacing: 3,
                        color: AppTheme.nearlyWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
