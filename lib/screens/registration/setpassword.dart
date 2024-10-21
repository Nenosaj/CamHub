import 'package:flutter/material.dart';
import 'package:example/screens/authentication.dart';
//import 'package:example/screens/loadingstate.dart';


class SetPassword extends StatefulWidget {
  final String email;  

  const SetPassword({super.key, required this.email});

  @override
  SetPasswordState createState() => SetPasswordState();
}

class SetPasswordState extends State<SetPassword> {


  final Authentication authController = Authentication();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isPasswordValid = false;
  bool doPasswordsMatch = false;

  // Variables to store password values
  String password = '';
  String confirmPassword = '';

  @override
   void initState() {
    super.initState();
    _passwordController.addListener(_updatePassword);
    _confirmPasswordController.addListener(_updatePassword);

  }
  
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to update password and confirmPassword variables
  void _updatePassword() {
    setState(() {
      password = _passwordController.text;
      confirmPassword = _confirmPasswordController.text;

      isPasswordValid = _isValidPassword(password);
      doPasswordsMatch = password == confirmPassword && password.isNotEmpty;
    });
  }

  // Method to validate password complexity
  bool _isValidPassword(String password) {
    final containsLetter = password.contains(RegExp(r'[A-Za-z]'));
    final containsNumber = password.contains(RegExp(r'[0-9]'));
    final containsSpecialCharacter = password.contains(RegExp(r'[&$\/]'));
    final hasMinimumLength = password.length >= 8;

    return containsLetter &&
        containsNumber &&
        containsSpecialCharacter &&
        hasMinimumLength;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to plain white
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
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
              icon: const Icon(
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
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'SET PASSWORD',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              const Text('Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              const Text('Confirm Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Password Match Status
              Row(
                children: [
                  Icon(
                    doPasswordsMatch ? Icons.check_circle : Icons.cancel,
                    color: doPasswordsMatch ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    doPasswordsMatch
                        ? 'Passwords Match'
                        : 'Passwords Do Not Match',
                    style: TextStyle(
                      color: doPasswordsMatch ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Password Requirements
              Row(
                children: [
                  Icon(
                    isPasswordValid ? Icons.check_circle : Icons.cancel,
                    color: isPasswordValid ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text('Must be at least 8 characters'),
                ],
              ),
              Row(
                children: [
                  Icon(
                    isPasswordValid ? Icons.check_circle : Icons.cancel,
                    color: isPasswordValid ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                        'Must contain Alphabetical letters, Numbers, and Special Characters (&,/).'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: isPasswordValid && doPasswordsMatch
                        ? const Color(0xFF662C2B)
                        : Colors.grey, // Disable if password is invalid
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isPasswordValid && doPasswordsMatch
                        ? () async {
                          await authController.updatePassword(_passwordController.text, context);
                          }
                        : null, // Disable button if password is invalid
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 140, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Set Password',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
