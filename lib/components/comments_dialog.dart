import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripRemarksDialog extends GetResponsiveView{
  TripRemarksDialog({Key? key}) : super(key: key){
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('./assets/images/trucks.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
              child: TextFormField(
                controller: controller.remarks,
                maxLines: 5,
                keyboardType: TextInputType.text,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    label: const Text('Remarks'),
                    labelStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[900]!,
                    ),
                    hintText: 'Please provide more info about your trip',
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
                onPressed: controller.tripControl,
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
                        fontSize: 20,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
