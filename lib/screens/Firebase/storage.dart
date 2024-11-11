import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Function to upload a file and return its download URL
  Future<String?> uploadFile(String path, File file) async {
    try {
      Reference storageReference = _storage.ref().child(path);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // ignore: avoid_print
      print('Error uploading file: $e');
      return null;
    }
  }
}
