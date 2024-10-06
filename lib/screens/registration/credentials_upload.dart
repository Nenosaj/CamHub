import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/screens/registration/verification.dart';

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
