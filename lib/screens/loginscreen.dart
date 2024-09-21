import 'package:flutter/material.dart';
import 'signupscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CamHub App',
      debugShowCheckedModeBanner: false, // This removes the debug ribbon
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final Map<String, String> adminCredentials = {
    'email': 'admin',
    'password': 'admin123'
  };
  final Map<String, String> clientCredentials = {
    'email': 'client',
    'password': 'client123'
  };
  final Map<String, String> creativeCredentials = {
    'email': 'creative',
    'password': 'creative123'
  };

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background Image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/camhub_background.jpg'),
                  ),
                ),
              ),
              // Positioned Logo
              Positioned(
                left: 90,
                top: 100,
                child: Image.asset(
                  'assets/images/camhub_logo.jpg',
                  width: 250,
                  height: 250,
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
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Color(0xFF662C2B),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Welcome back!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Are you ready for your pose?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Username TextField
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'example@gmail.com',
                              labelText: 'Username',
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: Color(0xFF959595),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Password TextField
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '********',
                              labelText: 'Password',
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: Color(0xFF959595),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Log in Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFF662C2B),
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                  color: Color(0xFF662C2B), width: 2),
                            ),
                            onPressed: () {
                              final email = emailController.text;
                              final password = passwordController.text;

                              // Check against hardcoded credentials
                              if (email == adminCredentials['email'] &&
                                  password == adminCredentials['password']) {
                                Navigator.pushNamed(context, '/admin');
                              } else if (email == clientCredentials['email'] &&
                                  password == clientCredentials['password']) {
                                Navigator.pushNamed(context, '/client');
                              } else if (email ==
                                      creativeCredentials['email'] &&
                                  password == creativeCredentials['password']) {
                                Navigator.pushNamed(context, '/creative');
                              } else {
                                // Show an error if login fails
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Login Failed'),
                                    content: Text('Invalid email or password.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Sign-up Link
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
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
          );
        },
      ),
    );
  }
}
