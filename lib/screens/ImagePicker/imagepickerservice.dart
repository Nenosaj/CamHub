// image_picker_service.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (await Permission.storage.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image != null ? File(image.path) : null;
    }
    return null;
  }

  // In image_picker_service.dart
Future<File?> pickVideoFromGallery() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  if (await Permission.storage.isGranted) {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    return video != null ? File(video.path) : null;
  }
  return null;
}

}
