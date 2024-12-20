import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

class CreativeMessagingPlusButton extends StatefulWidget {
  final VoidCallback onPermissionGranted; // Callback when permission is granted

  const CreativeMessagingPlusButton(
      {super.key, required this.onPermissionGranted});

  @override
  CreativeMessagingPlusButtonState createState() =>
      CreativeMessagingPlusButtonState();
}

class CreativeMessagingPlusButtonState
    extends State<CreativeMessagingPlusButton> {
  bool _permissionGranted = false; // Track if permission is granted

  // Show permission dialog only if permission is not yet granted
  void _showPermissionDialog() {
    if (_permissionGranted) {
      widget
          .onPermissionGranted(); // Directly toggle the media grid if permission already granted
      return;
    }

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
              "Allow CamHub to access photos and media on your device?"),
          actions: [
            TextButton(
              child: const Text(
                "Deny",
                style: TextStyle(color: Color(0xFF662C2B)),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without showing the media grid
              },
            ),
            TextButton(
              child: const Text(
                "Allow",
                style: TextStyle(color: Color(0xFF662C2B)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _permissionGranted = true; // Mark permission as granted
                });
                widget
                    .onPermissionGranted(); // Proceed with showing the media grid
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return GestureDetector(
      onTap:
          _showPermissionDialog, // Show the dialog on tapping the plus button
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF662C2B), // Maroon background color
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
