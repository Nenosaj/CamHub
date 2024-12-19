import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<dynamic> pickImageFromGallery() async {
    if (kIsWeb) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image != null ? await image.readAsBytes() : null;
    } else {
      if (await _requestStoragePermission()) {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        return image != null ? File(image.path) : null;
      }
    }
    return null;
  }
  Future<dynamic> pickVideoFromGallery() async {
    if (kIsWeb) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      return video != null ? await video.readAsBytes() : null;
    } else {
      if (await _requestStoragePermission()) {
        final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
        return video != null ? File(video.path) : null;
      }
    }
    return null;
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isGranted) return true;

      if (await Permission.manageExternalStorage.request().isGranted ||
          await Permission.storage.request().isGranted) {
        return true;
      }
    }
    return false;
  }
}
