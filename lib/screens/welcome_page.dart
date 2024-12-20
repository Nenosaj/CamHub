import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For the delayed transition
import 'package:example/screens/LogIn/loginscreen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController for the rotation
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Rotation duration
      vsync: this,
    )..repeat(); // Makes the animation loop indefinitely

    // Automatically transition to LoginScreen after 5 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/camhub_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rotating Camera Icon
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2.0 * 3.141592653589793,
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 100, // Camera size
                    color: const Color(0xFF662C2B),
                  ),
                ),
                const SizedBox(height: 20),
                // Welcome Text
                const Text(
                  "Welcome to CamHub",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF662C2B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
