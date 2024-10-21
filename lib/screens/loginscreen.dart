import 'package:example/screens/authentication.dart';
import 'package:flutter/material.dart';
import 'registration/signupscreen.dart';

//import 'package:example/screens/loadingstate.dart';

void main() {
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CamHub App',
      debugShowCheckedModeBanner: false, // This removes the debug ribbon
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Authentication authController = Authentication();

  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Boolean to track password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            // Scrollable content
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // Background Image
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage('assets/images/camhub_background.jpg'),
                        ),
                      ),
                    ),
                    // Positioned Logo
                    Positioned(
                      left: 90,
                      top: 80,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(85, 85, 84, 84)
                                  .withOpacity(
                                      0.4), // Shadow color with opacity
                              spreadRadius: 1, // How wide the shadow spreads
                              blurRadius: 20, // How soft the shadow is
                              offset: const Offset(2,
                                  1), // Horizontal and vertical offset of the shadow
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/camhub_logo.jpg',
                          width: 250,
                          height: 250,
                        ),
                      ),
                    ),
                    // Adjust based on the visibility of the keyboard
                    Positioned(
                      top: MediaQuery.of(context).viewInsets.bottom > 0
                          ? constraints.maxHeight * 0.25
                          : constraints.maxHeight * 0.50,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          // Maroon Container
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: const BoxDecoration(
                              color: Color(0xFF662C2B),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Welcome back!',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Are you ready for your pose?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 0),
                                // Username TextField
                                Stack(
                                  children: [
                                    const Positioned(
                                      left: 10,
                                      top: 0,
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: TextField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          hintText: 'example@gmail.com',
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle: const TextStyle(
                                            color: Color(0xFF959595),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 0),
                                // Password TextField
                                Stack(
                                  children: [
                                    const Positioned(
                                      left: 10,
                                      top: 0,
                                      child: Text(
                                        'Password',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: TextField(
                                        controller: passwordController,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                          hintText: '********',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle: const TextStyle(
                                            color: Color(0xFF959595),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // Log in Button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xFF662C2B),
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 120, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    side: const BorderSide(
                                        color: Color(0xFF662C2B), width: 2),
                                  ),
                                  onPressed: () {
                                    final email = emailController.text;
                                    final password = passwordController.text;

                                    authController.signIn(
                                        email, password, context);
                                  },
                                  child: const Text(
                                    'Log in',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 0),
                                // Sign-up Link
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen()),
                                    );
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                      text: "Don't have an account? ",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Sign Up",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
