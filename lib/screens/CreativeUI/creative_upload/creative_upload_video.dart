import 'package:example/screens/Firebase/firestoreservice.dart';
import 'package:example/screens/ImagePicker/imagepickerservice.dart';
import 'package:example/screens/Firebase/storage.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/CreativeUI/creative_upload/creative_upload_selectcategory.dart';
import 'package:example/screens/Firebase/authentication.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class UploadVideos extends StatefulWidget {
  const UploadVideos({super.key});

  @override
  UploadVideosState createState() => UploadVideosState();
}

class UploadVideosState extends State<UploadVideos> {
  String? selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePickerService _imagePickerService = ImagePickerService();
  final Storage _storage = Storage();
  final Authentication _authenticationService = Authentication();

  final List<File> _selectedVideos = [];

  // Placeholder function for video selection
  Future<void> pickVideo() async {
    if (_selectedVideos.length < 5) {
      File? pickedVideo = await _imagePickerService.pickVideoFromGallery();

      if (pickedVideo != null) {
        // Use VideoPlayerController to check video duration
        VideoPlayerController controller =
            VideoPlayerController.file(pickedVideo);
        await controller.initialize();
        Duration videoDuration = controller.value.duration;

        if (videoDuration.inSeconds > 30) {
          // Show error message if video is longer than 30 seconds
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please select a video less than 30 seconds.')),
          );
        } else {
          // Add to the list if the duration is valid
          setState(() {
            _selectedVideos.add(pickedVideo);
          });
        }

        // Dispose of the controller after use
        controller.dispose();
      }
    } else {
      // Display a message if the user tries to add more than 5 videos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only select up to 5 videos.')),
      );
    }
  }

  Future<String?> _generateThumbnail(String videoPath) async {
    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 100, // Height of the thumbnail
      quality: 75,
    );
    return thumbnailPath;
  }

  // Widget to display video thumbnails
  Widget _buildVideoThumbnails() {
    return Wrap(
      spacing: 8.0,
      children: _selectedVideos.map((file) {
        return FutureBuilder<String?>(
          future: _generateThumbnail(file.path),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 100,
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return Image.file(
                File(snapshot.data!),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            } else {
              return const SizedBox(
                width: 100,
                height: 100,
                child: Icon(Icons.videocam, size: 50, color: Colors.grey),
              );
            }
          },
        );
      }).toList(),
    );
  }

  // Function to handle image upload and data submission
  Future<void> _uploadAndSubmit() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String? category = selectedCategory;
    String location = _locationController.text.trim();
    String? creativeUid = _authenticationService
        .getCurrentUser()
        ?.uid; // Replace this with the actual creative's UID

    //print(creativeUid);

    if (title.isEmpty ||
        description.isEmpty ||
        category == null ||
        location.isEmpty ||
        _selectedVideos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill all fields and select at least one video.')),
      );
      return;
    }

    // Generate unique timestamp for this upload to use in storage paths
    String createdAt = DateTime.now().millisecondsSinceEpoch.toString();
    List<String> videoUrls = [];

    // Upload each selected image to Firebase Storage
    List<File> videosToUpload = List.from(_selectedVideos);

    for (var video in videosToUpload) {
      String? downloadUrl = await _storage.uploadFile(
          'videos/$creativeUid/$createdAt/${video.path.split('/').last}',
          video);
      if (downloadUrl != null) {
        videoUrls.add(downloadUrl);
      }
    }

    // Save the data to Firestore
    await _firestoreService.addVideoDetails(
      uid: creativeUid!,
      videoDetails: {
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'createdAt': DateTime.now(),
        'videos': videoUrls, // List of image URLs
      },
    );

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Upload Successful')),
    );

    // Clear the form after submission
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      selectedCategory = null;
      _locationController.clear();
      _selectedVideos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Upload Videos',
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
            // Title and Description Input
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
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

            // Select Category and Location inside a white box
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
                  // Select Category
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

                  // Location Selection
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
              'Upload Videos Here:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: pickVideo,
              child: Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _selectedVideos.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                      )
                    : _buildVideoThumbnails(),
              ),
            ),
            const SizedBox(height: 20.0),

            // Post Button
            Center(
              child: ElevatedButton(
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
