// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:example/screens/registration/setpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Verification extends StatefulWidget {
  final String email;
  const Verification({Key? key, required this.email}) : super(key: key);

  @override
  VerificationState createState() => VerificationState();
}

class VerificationState extends State<Verification> {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    

  final _digitControllers =
      List.generate(4, (index) => TextEditingController());
  final _focusNodes = List.generate(4, (index) => FocusNode());
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    _digitControllers.forEach((controller) {
      controller.addListener(() {
        setState(() {
          isComplete = _digitControllers
              .every((controller) => controller.text.isNotEmpty);
        });
      });
    });
  }

  @override
  void dispose() {
    _digitControllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  Widget buildDigitBox(int index) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 4), // Inner shadow
          ),
        ],
      ),
      child: TextField(
        controller: _digitControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context)
                .requestFocus(_focusNodes[index + 1]); // Move to the next box
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[
                index - 1]); // Move back to the previous box if empty
          }
        },
      ),
    );
  }

Future<void> checkEmailVerification() async {
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
      body: Padding(
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
              'Enter 4 digit verification code sent to your registered e-mail.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => buildDigitBox(index)),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Resend Code Logic
              },
              child: RichText(
                text: TextSpan(
                  text: "Didn't receive code? ",
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
                      offset: Offset(0, 4), // Shadow to give a floating effect
                    ),
                  ],
                ),
                child: ElevatedButton(
                      onPressed: isComplete
                      ? () async {
                          // Call checkEmailVerification to verify the email before navigating
                          await checkEmailVerification();
                        }
                      : null, // Disable button if the input is incomplete
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
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


