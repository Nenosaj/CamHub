import 'package:flutter/material.dart';

class CreativeUploadButton extends StatelessWidget {
  const CreativeUploadButton({super.key});

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOptionButton(
                  context,
                  icon: Icons.photo_camera,
                  label: 'PHOTOS',
                  onTap: () {
                    // Handle photo upload logic
                    Navigator.of(context).pop(); // Close after action
                  },
                ),
                _buildOptionButton(
                  context,
                  icon: Icons.local_shipping,
                  label: 'PACKAGE',
                  onTap: () {
                    // Handle package upload logic
                    Navigator.of(context).pop(); // Close after action
                  },
                ),
                _buildOptionButton(
                  context,
                  icon: Icons.video_library,
                  label: 'VIDEOS',
                  onTap: () {
                    // Handle video upload logic
                    Navigator.of(context).pop(); // Close after action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
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
