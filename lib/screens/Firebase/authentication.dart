import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:example/screens/SignUp/setpassword.dart';
import 'package:example/screens/LogIn/loginscreen.dart';
import 'package:example/main.dart';
import 'package:example/screens/Firebase/firestoreservice.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

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

      if (uid.isEmpty) throw Exception('User ID is empty.');
      await _firestoreService.addUser(uid: uid, email: email, userType: 'client');




        // Add client-specific details to Firestore
        await _firestoreService.addClientDetails(uid: uid, clientDetails: {
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

        
        // ignore: use_build_context_synchronously
        Navigator.push( context,
          MaterialPageRoute(
            builder: (context) => SetPassword(email: email),
          ),
        );
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      // ignore: use_build_context_synchronously
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
      if (uid.isEmpty) throw Exception("User ID is null or empty.");


      // Store general user information in the 'users' collection
      await _firestoreService.addUser(uid: uid, email: businessEmail, userType: 'creative');

      // Store creative-specific information in the 'creatives' collection
      await _firestoreService.addCreativeDetails(uid: uid, creativeDetails: {        
        'businessName': businessName,
        'unitNumber': unitNumber,
        'street': street,
        'village': village,
        'barangay': barangay,
        'city': city,
        'province': province,
        'businessPhoneNumber': businessPhoneNumber,
      }).catchError((error) {
        // ignore: avoid_print
        print('Failed to add creative: $error');
      });
      
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => SetPassword(email: businessEmail),
          ),
        );
       
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  // Function to update the user's password
  Future<void> registrationPassword(String newPassword, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()), // Navigating to login
        );

      } else {
        throw FirebaseAuthException(
            code: 'no-current-user',
            message: 'No user is currently signed in.');
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      _handleFirebaseErrors(e, context);
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      // ignore: use_build_context_synchronously
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
      String uid = userCredential.user?.uid ?? '';

      String userType = await _firestoreService.getUserType(uid);

      // Navigate based on user type
      if (userType == 'client') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/client');
      } else if (userType == 'creative') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/creative');
      } else if (userType == 'admin') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        // Handle case where no valid role is found
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid user role.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      
      // ignore: avoid_print
      print('error: ${e.code}');
      // ignore: avoid_print
      print('Error message: ${e.message}');

      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted .';
      }
        else {
        errorMessage = 'Incorrect Username or Password. Please try again.';
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
                errorMessage,
            style: TextStyle(color: Colors.white), // White text for visibility
          ),
          backgroundColor: Colors.red, // Red background for the container
        ),
      );
    } catch (e) {
      // Handle other errors
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => const MyApp()), // Redirects to MyApp
        (Route<dynamic> route) => false, // Removes all routes
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
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
