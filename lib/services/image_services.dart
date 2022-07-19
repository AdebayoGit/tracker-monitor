import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:viewer/models/response_status.dart';

class ImageServices {

  late final FirebaseStorage _storage;

  late final ImagePicker _imagePicker;

  final ImageSource camera = ImageSource.camera;

  final ImageSource gallery = ImageSource.gallery;

  ImageServices() {
    _storage = FirebaseStorage.instance;

    _imagePicker = ImagePicker();
  }

  Future<File?> captureImage({required ImageSource source}) async {
    return await _imagePicker.pickImage(source: source).then((XFile? image) {

      if (image != null){
        return File(image.path);
      }
      return null;
    });
  }

  Future<Status> uploadImage({required String username, required File image}) async {
    try {
      File compressedImage = await compressImage(image: image);
      Reference ref = _storage.ref().child("drivers_images/$username");
      String photoUrl = await ref.putFile(compressedImage).then((TaskSnapshot snapshot) =>
          snapshot.ref.getDownloadURL());
      return Success(response: photoUrl);
    } on Exception catch (e) {
      return Failure(code: "Error", response: "Unable to upload image");
    }
  }

  Future<File> compressImage({required File image}) async {
    final String dir = (await getExternalStorageDirectory())!.path;
    final String path = '$dir/image.jpg';
    File? result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      path,
      quality: 80,
      minHeight: 500,
      minWidth: 500,
    );
    return result!;
  }
}
