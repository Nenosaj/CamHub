import 'package:example/screens/Firebase/authentication.dart';
import 'package:flutter/material.dart';
import '../SignUp/signupscreen.dart';

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

  // Boolean to track loading state
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
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
                      left: screenWidth * 0.2, // Adjusted dynamically
                      top: screenHeight * 0.1, // Adjusted dynamically
                      child: Container(
                        width: screenWidth * 0.6, // Adjusted dynamically
                        height: screenWidth * 0.6, // Keeping it square
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(85, 85, 84, 84)
                                  .withOpacity(
                                      0.4), // Shadow color with opacity
                              spreadRadius: 1, // How wide the shadow spreads
                              blurRadius: 20, // How soft the shadow is
                              offset: const Offset(
                                  2, 1), // Horizontal and vertical offset
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/camhub_logo.jpg',
                          width: screenWidth * 0.6,
                          height: screenWidth * 0.6,
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).viewInsets.bottom > 0
                          ? screenHeight * 0.25
                          : screenHeight * 0.50, // Adjusted dynamically
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                                screenWidth * 0.06), // Adjusted dynamically
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
                                SizedBox(
                                    height: screenHeight *
                                        0.01), // Adjusted dynamically
                                const Text(
                                  'Are you ready for your pose?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                    height: screenHeight *
                                        0.02), // Adjusted dynamically
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
                                      padding: EdgeInsets.only(
                                          top: screenHeight * 0.03),
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
                                SizedBox(
                                    height: screenHeight *
                                        0.02), // Adjusted dynamically
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
                                      padding: EdgeInsets.only(
                                          top: screenHeight * 0.03),
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
                                SizedBox(
                                    height: screenHeight *
                                        0.03), // Adjusted dynamically
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Log in Button
                                    if (!_isLoading)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFF662C2B),
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.3,
                                            vertical: screenHeight * 0.02,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          side: const BorderSide(
                                              color: Color(0xFF662C2B),
                                              width: 2),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          final email = emailController.text;
                                          final password =
                                              passwordController.text;
                                          await authController.signIn(
                                              email, password, context);

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                        child: const Text(
                                          'Log in',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    // Loading Indicator
                                    if (_isLoading)
                                      const CircularProgressIndicator(),
                                  ],
                                ),
                                SizedBox(
                                    height: screenHeight *
                                        0.02), // Adjusted dynamically
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
