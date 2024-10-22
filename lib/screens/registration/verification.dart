// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:example/screens/registration/setpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart'; // Import the pinput package

class Verification extends StatefulWidget {
  final String email;
  const Verification({super.key, required this.email});

  @override
  VerificationState createState() => VerificationState();
}

class VerificationState extends State<Verification> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool isComplete = false;

  // Loading state
  bool _isLoading = false;

  // Pin decoration settings
  final PinTheme defaultPinTheme = PinTheme(
    width: 40,
    height: 55,
    textStyle: const TextStyle(fontSize: 25, color: Colors.black),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
  );

  Future<void> checkEmailVerification() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    User? user = _auth.currentUser;

    // Reload the user to get the latest email verification status
    await user?.reload();

    if (user?.emailVerified ?? false) {
      // Navigate to the setpassword.dart page if email is verified
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetPassword(email: widget.email),
        ),
      );
    } else {
      // Show a message if the email is not verified
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please verify your email before proceeding')),
      );
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to plain white
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF662C2B), // Maroon color as background
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), // Bottom left radius
              bottomRight: Radius.circular(20), // Bottom right radius
            ),
          ),
          child: AppBar(
            title: const Text(
              'Create New Account',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading spinner
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    'VERIFICATION',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter the 6-digit verification code sent to your registered email.', // Updated to reflect 6 digits
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Pinput(
                    length: 6,
                    controller: _pinPutController,
                    focusNode: _pinPutFocusNode,
                    defaultPinTheme: defaultPinTheme,
                    onCompleted: (String pin) {
                      // Handle pin submit logic here
                      setState(() {
                        isComplete = pin.length == 6;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Resend Code Logic
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Didn't receive the code? ",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: const [
                          TextSpan(
                            text: "Resend Code",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isComplete
                            ? Color(0xFF662C2B)
                            : Colors.grey, // Button color based on completeness
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(
                                0, 4), // Shadow to give a floating effect
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isComplete
                            ? () async {
                                await checkEmailVerification(); // Call the function to verify email
                              }
                            : null, // Disable button if the input is incomplete
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 120, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
