import 'package:example/screens/Firebase/firestoreservice.dart';
import 'package:example/screens/ImagePicker/imagepickerservice.dart';
import 'package:example/screens/Firebase/storage.dart';
import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/CreativeUI/creative_upload/creative_upload_selectcategory.dart';
import 'package:example/screens/Firebase/authentication.dart';

import 'dart:io';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  UploadImageState createState() => UploadImageState();
}

class UploadImageState extends State<UploadImage> {
  String? selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePickerService _imagePickerService = ImagePickerService();
  final Storage _storage = Storage();
  final Authentication _authenticationService = Authentication();

  final List<File> _selectedImages = [];
  bool _isUploading = false; // Tracks upload state

  // Placeholder function for image selection
  Future<void> _pickImage() async {
    if (_selectedImages.length < 5) {
      File? pickedImage = await _imagePickerService.pickImageFromGallery();
      if (pickedImage != null) {
        setState(() {
          _selectedImages.add(pickedImage);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only select up to 5 images.')),
      );
    }
  }

  // Function to handle image upload and data submission
  Future<void> _uploadAndSubmit() async {
    if (_isUploading) return;

    setState(() {
      _isUploading = true;
    });

    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String? category = selectedCategory;
    String location = _locationController.text.trim();
    String? creativeUid = _authenticationService.getCurrentUser()?.uid;

    if (title.isEmpty ||
        description.isEmpty ||
        category == null ||
        location.isEmpty ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill all fields and select at least one image.')),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    try {
      String createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      List<String> imageUrls = [];

      for (var image in _selectedImages) {
        String? downloadUrl = await _storage.uploadFile(
            'images/$creativeUid/$createdAt/${image.path.split('/').last}',
            image);
        if (downloadUrl != null) {
          imageUrls.add(downloadUrl);
        }
      }

      await _firestoreService.addImageDetails(
        uid: creativeUid!,
        imageDetails: {
          'title': title,
          'description': description,
          'category': category,
          'location': location,
          'createdAt': DateTime.now(),
          'images': imageUrls,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload Successful')),
      );

      setState(() {
        _titleController.clear();
        _descriptionController.clear();
        selectedCategory = null;
        _locationController.clear();
        _selectedImages.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload Failed: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Upload Image',
            style: TextStyle(
                color: Color(0xFF662C2B), fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      hintText: 'TYPE TITLE',
                      hintStyle: TextStyle(
                        color: Color(0xFF662C2B),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      hintText: 'Type description here',
                      hintStyle: TextStyle(
                        color: Color(0xFF662C2B),
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SelectCategory(
                          onCategorySelected: (String category) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCategory ?? 'Select Category',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      hintText: 'Type location here',
                      hintStyle: TextStyle(
                        color: Color(0xFF662C2B),
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            const Text(
              'Upload Images Here:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _selectedImages.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                      )
                    : Wrap(
                        spacing: 8.0,
                        children: _selectedImages.map((file) {
                          return Image.file(file, width: 100, height: 100);
                        }).toList(),
                      ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF662C2B),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 150.0,
                          vertical: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'POST',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
