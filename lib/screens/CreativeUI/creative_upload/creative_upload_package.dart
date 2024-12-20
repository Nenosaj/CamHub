import 'package:example/screens/ImagePicker/imagepickerservice.dart';
import 'package:example/screens/Firebase/storage.dart';
import 'package:example/screens/Firebase/firestoreservice.dart';
import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/Firebase/authentication.dart';
import 'package:example/screens/CreativeUI/creative_upload/creative_upload_selectcategory.dart';

import 'dart:io';

class UploadPackage extends StatefulWidget {
  const UploadPackage({super.key});

  @override
  UploadPackageState createState() => UploadPackageState();
}

class UploadPackageState extends State<UploadPackage> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final FirestoreService _firestoreService = FirestoreService();
  final Storage _storage = Storage();
  final Authentication _authenticationService = Authentication();

  String? _title;
  String? _description;
  String? _price;
  String? selectedCategory;
  File? _selectedImage;

  List<String> addOns = [""]; // Add-ons list
  List<String> addOnPrices = [""]; // Add-on prices list

  bool _isUploading = false; // Tracks upload state

  // Function to pick an image
  Future<void> _pickImage() async {
    File? pickedImage = await _imagePickerService.pickImageFromGallery();
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  // Functions for Add-ons
  void addNewAddOn() {
    setState(() {
      addOns.add("");
      addOnPrices.add("");
    });
  }

  void removeLastAddOn() {
    if (addOns.length > 1) {
      setState(() {
        addOns.removeLast();
        addOnPrices.removeLast();
      });
    }
  }

  // Function to validate numeric input
  String? validateNumericInput(String? input) {
    if (input == null || input.isEmpty) return null;
    final parsedValue = int.tryParse(input);
    if (parsedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid numeric value.')),
      );
      return null;
    }
    return input;
  }

  // Function to validate Add-Ons
  bool _validateAddOns() {
    for (int i = 0; i < addOns.length; i++) {
      if (addOns[i].isEmpty || addOnPrices[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add-on ${i + 1} is incomplete.')),
        );
        return false;
      }
      if (int.tryParse(addOnPrices[i]) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add-on ${i + 1} price must be numeric.')),
        );
        return false;
      }
    }
    return true;
  }

  // Function to upload the package
  // Function to upload the package
  Future<void> _uploadAndSubmit() async {
    String? creativeUid = _authenticationService.getCurrentUser()?.uid;

    if (_isUploading) return;

    if (_title == null || _title!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required.')),
      );
      return;
    }
    if (_description == null || _description!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description is required.')),
      );
      return;
    }
    _price = validateNumericInput(_price); // Ensure price is numeric
    if (_price == null) return;

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An image is required.')),
      );
      return;
    }
    if (!_validateAddOns()) return;

    setState(() {
      _isUploading = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading...')),
    );

    try {
      String createdAt = DateTime.now().millisecondsSinceEpoch.toString();

      // Image Upload
      String? imageUrl;
      try {
        imageUrl = await _storage.uploadFile(
            'package/$creativeUid/$createdAt/${_selectedImage!.path.split('/').last}',
            _selectedImage!);
        if (imageUrl == null) throw Exception('Image upload failed.');
      } catch (e) {
        throw Exception('Image upload failed: $e');
      }

      // Add-on Preparation
      List<Map<String, String>> addOnDetails = [];
      for (int i = 0; i < addOns.length; i++) {
        addOnDetails.add({"addOn": addOns[i], "price": addOnPrices[i]});
      }

      // Firestore Upload
      await _firestoreService.addPackageDetails(
        uid: creativeUid!,
        packageDetails: {
          'title': _title,
          'description': _description,
          'category': selectedCategory ?? 'Uncategorized',
          'price': _price,
          'package': imageUrl,
          'addOns': addOnDetails,
          'createdAt': DateTime.now(),
        },
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload Successful!')),
      );

      // Reset the form
      setState(() {
        _title = null;
        _description = null;
        _price = null;
        _selectedImage = null;
        addOns = [""];
        addOnPrices = [""];
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
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
        title: const Text('Upload Package',
            style: TextStyle(
                color: Color(0xFF662C2B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Description
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) => _title = value,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => _description = value,
            ),
            const SizedBox(height: 10),

            // Price
            TextField(
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) => _price = validateNumericInput(value),
            ),
            const SizedBox(height: 10),

            // Category Selection
            ListTile(
              title: Text(selectedCategory ?? 'Select Category'),
              trailing: const Icon(Icons.arrow_forward_ios),
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
            ),
            const SizedBox(height: 10),

            // Image Upload
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _selectedImage == null
                    ? const Center(child: Icon(Icons.add_a_photo, size: 50))
                    : Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),

            // Add-ons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add-ons', style: TextStyle(fontSize: 16.0)),
                Row(
                  children: [
                    IconButton(
                      onPressed: addNewAddOn,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    IconButton(
                      onPressed: removeLastAddOn,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: addOns.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration:
                            const InputDecoration(hintText: 'Add-on Name'),
                        onChanged: (value) => addOns[index] = value,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration:
                            const InputDecoration(hintText: 'Add-on Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => addOnPrices[index] =
                            validateNumericInput(value) ?? "",
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // POST Button
            Center(
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF662C2B),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                      ),
                      child: const Text(
                        'POST',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
