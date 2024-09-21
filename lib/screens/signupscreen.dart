import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'clienthomepage.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar height
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
                color: Colors.white, // Set the text color to white
              ),
            ),
            centerTitle: true,
            backgroundColor:
                Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove AppBar shadow
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white, // Set the back button color to white
              ),
              onPressed: () {
                Navigator.pop(context); // Back navigation functionality
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: BoxDecoration(
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
              crossAxisAlignment:
                  CrossAxisAlignment.start, // No vertical centering
              children: <Widget>[
                const SizedBox(height: 30),
                const Text(
                  'REGISTER AS:',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A2E2E), // Same maroon text color
                  ),
                ),
                const SizedBox(height: 50),

                // Centered Creatives Role Button (horizontally)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FillUpPageCreatives()),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2, // How much the shadow spreads
                                blurRadius: 6, // How soft the shadow is
                                offset: Offset(0, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 80,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'CREATIVES',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A2E2E), // Matching maroon color
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FillUpPageClient()),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white, // Plain white background
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255,
                                  255), // Border color remains white
                              width: 20,
                            ),
                            borderRadius: BorderRadius.circular(
                                20), // Border radius as per original code
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2, // How much the shadow spreads
                                blurRadius: 6, // How soft the shadow is
                                offset: Offset(0, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: 100,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'CLIENT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A2E2E), // Matching maroon color
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

// The FillUpPageCreatives class
class FillUpPageCreatives extends StatefulWidget {
  @override
  _FillUpPageCreativesState createState() => _FillUpPageCreativesState();
}

class _FillUpPageCreativesState extends State<FillUpPageCreatives> {
  bool isPrivacyChecked = false; // For first checkbox
  bool isTermsChecked = false; // For second checkbox
  bool showError =
      false; // Flag to show error message if checkboxes are not ticked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar height
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
                color: Colors.white, // Set the text color to white
              ),
            ),
            centerTitle: true,
            backgroundColor:
                Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove AppBar shadow
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white, // Set the back button color to white
              ),
              onPressed: () {
                Navigator.pop(context); // Back navigation functionality
              },
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Set the background color to plain white
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField('First Name'),
                buildTextField('Middle Name'),
                buildTextField('Last Name'),
                buildTextField('Birthday', isDateField: true),
                buildTextField('Unit No./House No./Building Number'),
                buildTextField('Street'),
                buildTextField('Village/Subdivision'),
                buildTextField('Barangay'),
                buildTextField('City'),
                buildTextField('Province'),
                buildTextField('Email'),
                buildTextField('Phone Number'),
                SizedBox(height: 20),
                // Privacy Checkbox
                buildCheckbox(
                  context,
                  'I agree to the collection and use of data that I have provided to CamHUB through this application. I understand that the collection and use of this data, which may include personal information and sensitive personal information, shall be in accordance with the ',
                  'Privacy Policy of CamHUB',
                  isPrivacyChecked,
                  (value) {
                    setState(() {
                      isPrivacyChecked = value!;
                    });
                  },
                ),
                SizedBox(height: 5),
                // Terms Checkbox
                buildCheckbox(
                  context,
                  'I agree to the ',
                  'Terms and Conditions of CamHUB',
                  isTermsChecked,
                  (value) {
                    setState(() {
                      isTermsChecked = value!;
                    });
                  },
                ),
                if (showError)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Please agree to the Privacy Policy and Terms to continue.',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: (isPrivacyChecked && isTermsChecked)
                          ? Color(0xFF662C2B)
                          : Colors.grey, // Change color based on checkbox state
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0,
                              4), // Shadow position to give a floating effect
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: (isPrivacyChecked && isTermsChecked)
                          ? () {
                              // Navigate to the CredentialsUpload class
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CredentialsUpload()),
                              );
                            }
                          : () {
                              setState(() {
                                showError =
                                    true; // Show error message if not ticked
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Make the button background transparent to show Container color
                        shadowColor: Colors
                            .transparent, // Remove default shadow of ElevatedButton
                        padding:
                            EdgeInsets.symmetric(horizontal: 140, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded edges
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create a TextField with the label
  Widget buildTextField(String label, {bool isDateField = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextField(
            readOnly: isDateField, // Makes it readonly if it's a date field
            decoration: InputDecoration(
              hintText: isDateField ? 'Choose Date' : 'Enter Here',
              suffixIcon: isDateField
                  ? Icon(Icons.calendar_today, color: Colors.grey)
                  : null,
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create a checkbox with text and a link
  Widget buildCheckbox(BuildContext context, String text, String linkText,
      bool isChecked, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center, // Align checkbox with the text vertically centered
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: text,
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: linkText,
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CredentialsUpload extends StatefulWidget {
  @override
  _CredentialsUploadState createState() => _CredentialsUploadState();
}

class _CredentialsUploadState extends State<CredentialsUpload> {
  bool isSmallBusinessChecked = false; // Checkbox for Small Business
  bool isLargeBusinessChecked = false; // Checkbox for Large Business
  List<Map<String, String>> files = [
    {'name': 'file.pdf', 'type': 'PDF'},
    {'name': 'bir.pdf', 'type': 'PDF'},
    {'name': 'ITR.png', 'type': 'PNG'}
  ]; // Example files for upload

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar height
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
                color: Colors.white, // Set the text color to white
              ),
            ),
            centerTitle: true,
            backgroundColor:
                Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove AppBar shadow
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white, // Set the back button color to white
              ),
              onPressed: () {
                Navigator.pop(context); // Back navigation functionality
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Name and Address Fields
              buildTextField('Business Name'),
              buildTextField('Unit No./House No./Building Number'),
              buildTextField('Street'),
              buildTextField('Village/Subdivision'),
              buildTextField('Barangay'),
              buildTextField('City'),
              buildTextField('Province'),
              buildTextField('Business Email'),
              buildTextField('Business Phone Number'),
              SizedBox(height: 20),

              // Business Type: Only one checkbox can be selected at a time
              Text('Scale of Business',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Checkbox(
                    value: isSmallBusinessChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isSmallBusinessChecked = value!;
                        isLargeBusinessChecked = false;
                      });
                    },
                  ),
                  Text('Small Business'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isLargeBusinessChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isLargeBusinessChecked = value!;
                        isSmallBusinessChecked = false;
                      });
                    },
                  ),
                  Text('Large Business'),
                ],
              ),

              SizedBox(height: 20),

              // Proof of Business Section
              Text(
                'Proof of Business',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Choose file:', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  // Upload Button with Shadow
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic to upload files can be added here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color
                        side: BorderSide(color: Colors.black), // Black border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.black), // Black text
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Uploaded Files with Delete Buttons
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(0, 2), // Shadow for inner box
                    ),
                  ],
                ),
                child: Column(
                  children: files.map((file) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 3), // Inner shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                              file['type'] == 'PDF'
                                  ? Icons.picture_as_pdf
                                  : Icons.image,
                              color: Colors.red),
                          SizedBox(width: 10),
                          Expanded(child: Text(file['name']!)),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                files.remove(file); // Logic to delete file
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Delete button color
                            ),
                            child: Row(
                              children: [
                                Text('Delete',
                                    style: TextStyle(color: Colors.white)),
                                Icon(Icons.delete,
                                    size: 16, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 10),

              // Note Section
              Text(
                'Note: Wait for 7-10 business days for the approval and verification',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ),

              SizedBox(height: 30),

              // Next Button to proceed to Verification
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF662C2B),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(
                            0, 4), // Shadow position to give a floating effect
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the Verification class
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Verification()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Make the button background transparent to show Container color
                      shadowColor: Colors
                          .transparent, // Remove default shadow of ElevatedButton
                      padding:
                          EdgeInsets.symmetric(horizontal: 140, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded edges
                      ),
                    ),
                    child: Text(
                      'Next',
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

  // Helper method to create a TextField with the label
  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter Here',
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FillUpPageClient extends StatefulWidget {
  @override
  _FillUpPageClientState createState() => _FillUpPageClientState();
}

class _FillUpPageClientState extends State<FillUpPageClient> {
  bool isPrivacyChecked = false; // For first checkbox
  bool isTermsChecked = false; // For second checkbox
  bool showError =
      false; // Flag to show error message if checkboxes are not ticked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar height
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
                color: Colors.white, // Set the text color to white
              ),
            ),
            centerTitle: true,
            backgroundColor:
                Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove AppBar shadow
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white, // Set the back button color to white
              ),
              onPressed: () {
                Navigator.pop(context); // Back navigation functionality
              },
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Set the background color to plain white
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField('First Name'),
                buildTextField('Middle Name'),
                buildTextField('Last Name'),
                buildTextField('Birthday', isDateField: true),
                buildTextField('Unit No./House No./Building Number'),
                buildTextField('Street'),
                buildTextField('Village/Subdivision'),
                buildTextField('Barangay'),
                buildTextField('City'),
                buildTextField('Province'),
                buildTextField('Email'),
                buildTextField('Phone Number'),
                SizedBox(height: 20),
                // Privacy Checkbox
                buildCheckbox(
                  context,
                  'I agree to the collection and use of data that I have provided to CamHUB through this application. I understand that the collection and use of this data, which may include personal information and sensitive personal information, shall be in accordance with the ',
                  'Privacy Policy of CamHUB',
                  isPrivacyChecked,
                  (value) {
                    setState(() {
                      isPrivacyChecked = value!;
                    });
                  },
                ),
                SizedBox(height: 5),
                // Terms Checkbox
                buildCheckbox(
                  context,
                  'I agree to the ',
                  'Terms and Conditions of CamHUB',
                  isTermsChecked,
                  (value) {
                    setState(() {
                      isTermsChecked = value!;
                    });
                  },
                ),
                if (showError)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Please agree to the Privacy Policy and Terms to continue.',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: (isPrivacyChecked && isTermsChecked)
                          ? Color(0xFF662C2B)
                          : Colors.grey, // Change color based on checkbox state
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0,
                              4), // Shadow position to give a floating effect
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: (isPrivacyChecked && isTermsChecked)
                          ? () {
                              // Navigate to the Verification class
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Verification()),
                              );
                            }
                          : () {
                              setState(() {
                                showError =
                                    true; // Show error message if not ticked
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Make the button background transparent to show Container color
                        shadowColor: Colors
                            .transparent, // Remove default shadow of ElevatedButton
                        padding:
                            EdgeInsets.symmetric(horizontal: 140, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded edges
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create a TextField with the label
  Widget buildTextField(String label, {bool isDateField = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextField(
            readOnly: isDateField, // Makes it readonly if it's a date field
            decoration: InputDecoration(
              hintText: isDateField ? 'Choose Date' : 'Enter Here',
              suffixIcon: isDateField
                  ? Icon(Icons.calendar_today, color: Colors.grey)
                  : null,
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create a checkbox with text and a link
  Widget buildCheckbox(BuildContext context, String text, String linkText,
      bool isChecked, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center, // Align checkbox with the text vertically centered
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: text,
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: linkText,
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
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
                  children: [
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
                      ? () {
                          // Navigate to the SetPassword class after verification
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SetPassword()),
                          );
                        }
                      : null, // Disable button if the input is incomplete
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 120, vertical: 15),
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

class SetPassword extends StatefulWidget {
  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isPasswordValid = false;
  bool doPasswordsMatch = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      isPasswordValid = _isValidPassword(password);
      doPasswordsMatch = password == confirmPassword && password.isNotEmpty;
    });
  }

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
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'SET PASSWORD',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),

              // Password Field
              Text('Password',
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
              SizedBox(height: 20),

              // Confirm Password Field
              Text('Confirm Password',
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
              SizedBox(height: 10),

              // Password Match Status
              Row(
                children: [
                  Icon(
                    doPasswordsMatch ? Icons.check_circle : Icons.cancel,
                    color: doPasswordsMatch ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  SizedBox(width: 10),
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
              SizedBox(height: 10),

              // Password Requirements
              Row(
                children: [
                  Icon(
                    isPasswordValid ? Icons.check_circle : Icons.cancel,
                    color: isPasswordValid ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text('Must be at least 8 characters'),
                ],
              ),
              Row(
                children: [
                  Icon(
                    isPasswordValid ? Icons.check_circle : Icons.cancel,
                    color: isPasswordValid ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                        'Must contain Alphabetical letters, Numbers, and Special Characters (&,/).'),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Sign Up Button
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: isPasswordValid && doPasswordsMatch
                        ? Color(0xFF662C2B)
                        : Colors.grey, // Disable if password is invalid
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset:
                            Offset(0, 4), // Shadow to give a floating effect
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isPasswordValid && doPasswordsMatch
                        ? () {
                            // Navigate to HomePage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage()), // Replace HomePage with the actual homepage class
                            );
                          }
                        : null, // Disable button if password is invalid
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 140, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
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
