import 'package:example/screens/SignUp/credentials_upload.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/SignUp/fillupclient.dart';
//import 'package:example/screens/loadingstate.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  // Variable to store selected role
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF662C2B), // Maroon color as background
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
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
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/camhub_background.jpg'),
                fit: BoxFit.cover, // Cover the whole screen
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                const Text(
                  'REGISTER AS:',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A2E2E),
                  ),
                ),
                const SizedBox(height: 50),

                // Centered Creatives Role Button (horizontally)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRole = 'Creatives'; // Set selected role
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CredentialsUpload(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: selectedRole == 'Creatives'
                                ? const Color.fromARGB(255, 230, 230, 230)
                                : const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 80,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'CREATIVES',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A2E2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Centered Client Role Button (horizontally)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRole = 'Client'; // Set selected role
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FillUpPageClient(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: selectedRole == 'Client'
                                ? const Color.fromARGB(255, 230, 230, 230)
                                : Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 20,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            size: 100,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'CLIENT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A2E2E),
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
    );
  }
}
