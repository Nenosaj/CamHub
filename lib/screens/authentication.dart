import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:example/screens/registration/setpassword.dart';
import 'package:example/screens/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../main.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to register a new client
  Future<void> registerClient(
      String email, String userType, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'TemporaryPassword123', // Temporary password
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'userType': userType, // Store whether the user is client or creative
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (userType == 'client') {
        // Navigate to the client-specific SetPassword page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPassword(email: email),
          ),
        );
      } else if (userType == 'creative') {
        // Navigate to the creative-specific SetPassword page or other pages
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPassword(email: email),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  // Function to update the user's password
  Future<void> updatePassword(String newPassword, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()), // Navigating to login
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully!')),
        );
      } else {
        throw FirebaseAuthException(
            code: 'no-current-user',
            message: 'No user is currently signed in.');
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseErrors(e, context);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password. Please try again.')),
      );
    }
  }

  // Error handling for Firebase
  void _handleFirebaseErrors(FirebaseAuthException e, BuildContext context) {
    String errorMessage;

    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'This email is already in use.';
        break;
      case 'invalid-email':
        errorMessage = 'Invalid email format.';
        break;
      case 'weak-password':
        errorMessage = 'The password is too weak.';
        break;
      default:
        errorMessage = 'An unknown error occurred.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      // Sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch the user's role from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      String userType = userDoc['userType'];

      // Navigate based on user type
      if (userType == 'client') {
        Navigator.pushReplacementNamed(context, '/client');
      } else if (userType == 'creative') {
        Navigator.pushReplacementNamed(context, '/creative');
      } else if (userType == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        // Handle case where no valid role is found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid user role.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const MyApp()), // Redirects to MyApp
        (Route<dynamic> route) => false, // Removes all routes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
}
