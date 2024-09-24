import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/screens/registration/verification.dart';

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
