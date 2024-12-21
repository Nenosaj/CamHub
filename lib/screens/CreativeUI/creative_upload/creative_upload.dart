import 'package:example/screens/CreativeUI/creative_upload/creative_upload_image.dart';
import 'package:example/screens/CreativeUI/creative_upload/creative_upload_package.dart';
import 'package:example/screens/CreativeUI/creative_upload/creative_upload_video.dart';
import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

class CreativeUploadButton extends StatefulWidget {
  const CreativeUploadButton({super.key});

  @override
  _CreativeUploadButtonState createState() => _CreativeUploadButtonState();
}

class _CreativeUploadButtonState extends State<CreativeUploadButton> {
  bool isLoading = false;

  void _setLoadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: const Color(0xFF7B3A3F), // Maroon background
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: 300.0,
        height: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Want to add something?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOptionButton(
                    context,
                    icon: Icons.photo_camera,
                    label: 'PHOTOS',
                    onTap: () async {
                      _setLoadingState(true);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadImage(),
                        ),
                      );
                      _setLoadingState(false);
                    },
                  ),
                  _buildOptionButton(
                    context,
                    icon: Icons.local_shipping,
                    label: 'PACKAGE',
                    onTap: () async {
                      _setLoadingState(true);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadPackage(),
                        ),
                      );
                      _setLoadingState(false);
                    },
                  ),
                  _buildOptionButton(
                    context,
                    icon: Icons.video_library,
                    label: 'VIDEOS',
                    onTap: () async {
                      _setLoadingState(true);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadVideos(),
                        ),
                      );
                      _setLoadingState(false);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: const Color(0xFF7B3A3F), // Maroon color for the icon
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
