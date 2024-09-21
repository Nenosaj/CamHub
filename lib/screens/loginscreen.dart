import 'package:flutter/material.dart';
import 'signupscreen.dart';

class LoginScreen extends StatelessWidget {
  // Hardcoded credentials for different roles
  final Map<String, String> adminCredentials = {'email': 'admin', 'password': 'admin123'};
  final Map<String, String> clientCredentials = {'email': 'client', 'password': 'client123'};
  final Map<String, String> creativeCredentials = {'email': 'creative', 'password': 'creative123'};

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Retrieve entered email and password
                String email = emailController.text;
                String password = passwordController.text;

                // Check against hardcoded credentials
                if (email == adminCredentials['email'] && password == adminCredentials['password']) {
                  Navigator.pushNamed(context, '/admin');
                } else if (email == clientCredentials['email'] && password == clientCredentials['password']) {
                  Navigator.pushNamed(context, '/client');
                } else if (email == creativeCredentials['email'] && password == creativeCredentials['password']) {
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
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to sign up screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
