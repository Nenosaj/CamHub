import 'package:flutter/material.dart';

class LoadingState {
  // Method to show or hide the loading indicator
  static void showLoading(BuildContext context, bool show) {
    if (show) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents closing by tapping outside
        builder: (BuildContext context) {
          return const Center(child: CameraLoadingIndicator());
        },
      );
    } else {
      // Hide loading indicator
      Navigator.of(context, rootNavigator: true).pop(); // Pop the dialog
    }
  }
}

class CameraLoadingIndicator extends StatefulWidget {
  const CameraLoadingIndicator({super.key});

  @override
  _CameraLoadingIndicatorState createState() => _CameraLoadingIndicatorState();
}

class _CameraLoadingIndicatorState extends State<CameraLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duration of one jump
    )..repeat(reverse: true); // Repeat the animation up and down

    // Define the animation to move up and down (jump)
    _animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Icon(
            Icons.camera_alt, // Camera icon
            size: 80.0, // Icon size
            color: const Color(0xFF662C2B), // Maroon color
          ),
        );
      },
    );
  }
}
