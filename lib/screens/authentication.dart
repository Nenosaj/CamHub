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
      String email,
      String firstName,
      String middleName,
      String lastName,
      String birthday,
      String unitNumber,
      String street,
      String village,
      String barangay,
      String city,
      String province,
      String phoneNumber,
      BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'TemporaryPassword123', // Temporary password
      );

      String uid = userCredential.user?.uid ?? '';

      if (uid.isNotEmpty) {
        // Add general user information to Firestore
        await _firestore.collection('users').doc(uid).set({
          'email': email,
          'userType': 'client',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Add client-specific details to Firestore
        await _firestore.collection('clients').doc(uid).set({
          'firstName': firstName,
          'middleName': middleName,
          'lastName': lastName,
          'birthday': birthday,
          'unitNumber': unitNumber,
          'street': street,
          'village': village,
          'barangay': barangay,
          'city': city,
          'province': province,
          'phoneNumber': phoneNumber,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPassword(email: email),
          ),
        );
      } else {
        print('User ID is empty, navigation aborted.');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  // Function to register a new creative
  Future<void> registerCreative(
      String businessEmail,
      String businessName, // Creatives may have business-specific details
      String unitNumber, // Example creative-specific detail
      String street,
      String village,
      String barangay,
      String city,
      String province,
      String businessPhoneNumber,
      BuildContext context) async {
    try {
      // Create the user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: businessEmail,
        password: 'TemporaryPassword123',
      );

      String uid = userCredential.user?.uid ?? '';
      if (uid.isEmpty) {
        print("User ID is null or empty.");
      }

      // Store general user information in the 'users' collection
      await _firestore.collection('users').doc(uid).set({
        'email': businessEmail,
        'userType': 'creative',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Store creative-specific information in the 'creatives' collection
      await _firestore.collection('creatives').doc(uid).set({
        'businessName': businessName,
        'unitNumber': unitNumber,
        'street': street,
        'village': village,
        'barangay': barangay,
        'city': city,
        'province': province,
        'businessPhoneNumber': businessPhoneNumber,
      }).catchError((error) {
        print('Failed to add creative: $error');
      });

      if (uid.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPassword(email: businessEmail),
          ),
        );
      } else {
        print('User ID is empty, navigation aborted.');
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
        errorMessage = 'Incorrect Username or Password. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Incorrect Username or Password. Please try again.',
            style: TextStyle(color: Colors.white), // White text for visibility
          ),
          backgroundColor: Colors.red, // Red background for the container
        ),
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

  // Method to get the current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // Add other authentication-related methods if needed
}
