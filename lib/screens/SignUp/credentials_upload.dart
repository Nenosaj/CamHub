import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/Firebase/authentication.dart';

class CredentialsUpload extends StatefulWidget {
  const CredentialsUpload({super.key});

  @override
  CredentialsUploadState createState() => CredentialsUploadState();
}

class CredentialsUploadState extends State<CredentialsUpload> {
  final Authentication authController = Authentication();

  bool isPrivacyChecked = false; // For first checkbox
  bool isTermsChecked = false; // For second checkbox
  bool showError =
      false; // Flag to show error message if checkboxes are not ticked

  bool allFieldsFilled = false;
  bool isLoading = false; // Loading state

  bool isSmallBusinessChecked = false; // Checkbox for Small Business
  bool isLargeBusinessChecked = false; // Checkbox for Large Business

  // Variables for form fields
  String businessName = '';
  String unitNumber = '';
  String street = '';
  String village = '';
  String barangay = '';
  String city = '';
  String province = '';
  String businessEmail = '';
  String businessPhoneNumber = '';

  // TextEditingControllers for text fields
  TextEditingController businessNameController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController barangayController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController businessEmailController = TextEditingController();
  TextEditingController businessPhoneNumberController = TextEditingController();

  // List to store uploaded files
  List<Map<String, String>> files = [
    {'name': 'file.pdf', 'type': 'PDF'},
    {'name': 'bir.pdf', 'type': 'PDF'},
    {'name': 'ITR.png', 'type': 'PNG'}
  ]; // Example files for upload

  @override
  void initState() {
    super.initState();
    _addValidationListeners();
  }

  void _addValidationListeners() {
    businessNameController.addListener(
        () => _updateField('businessName', businessNameController.text));
    unitNumberController.addListener(
        () => _updateField('unitNumber', unitNumberController.text));
    streetController
        .addListener(() => _updateField('street', streetController.text));
    villageController
        .addListener(() => _updateField('village', villageController.text));
    barangayController
        .addListener(() => _updateField('barangay', barangayController.text));
    cityController.addListener(() => _updateField('city', cityController.text));
    provinceController
        .addListener(() => _updateField('province', provinceController.text));
    businessEmailController.addListener(
        () => _updateField('businessEmail', businessEmailController.text));
    businessPhoneNumberController.addListener(() => _updateField(
        'businessPhoneNumber', businessPhoneNumberController.text));
  }

  void _updateField(String field, String value) {
    setState(() {
      switch (field) {
        case 'businessName':
          businessName = value;
          break;
        case 'unitNumber':
          unitNumber = value;
          break;
        case 'street':
          street = value;
          break;
        case 'village':
          village = value;
          break;
        case 'barangay':
          barangay = value;
          break;
        case 'city':
          city = value;
          break;
        case 'province':
          province = value;
          break;
        case 'businessEmail':
          businessEmail = value;
          break;
        case 'businessPhoneNumber':
          businessPhoneNumber = value;
          break;
      }
      _validateFields();
    });
  }

  void _validateFields() {
    setState(() {
      allFieldsFilled = businessName.isNotEmpty &&
          unitNumber.isNotEmpty &&
          street.isNotEmpty &&
          village.isNotEmpty &&
          barangay.isNotEmpty &&
          city.isNotEmpty &&
          province.isNotEmpty &&
          businessEmail.isNotEmpty &&
          businessPhoneNumber.isNotEmpty;
    });
  }

  @override
  void dispose() {
    businessNameController.dispose();
    unitNumberController.dispose();
    streetController.dispose();
    villageController.dispose();
    barangayController.dispose();
    cityController.dispose();
    provinceController.dispose();
    businessEmailController.dispose();
    businessPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // AppBar height
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
                color: Colors.white, // Set the text color to white
              ),
            ),
            centerTitle: true,
            backgroundColor:
                Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove AppBar shadow
            leading: IconButton(
              icon: const Icon(
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
              buildTextField('Business Name',
                  controller: businessNameController),
              buildTextField('Unit No./House No./Building Number',
                  controller: unitNumberController),
              buildTextField('Street', controller: streetController),
              buildTextField('Village/Subdivision',
                  controller: villageController),
              buildTextField('Barangay', controller: barangayController),
              buildTextField('City', controller: cityController),
              buildTextField('Province', controller: provinceController),
              buildTextField('Business Email',
                  controller: businessEmailController),
              buildTextField('Business Phone Number',
                  controller: businessPhoneNumberController),
              const SizedBox(height: 20),

              // Business Type: Only one checkbox can be selected at a time
              const Text('Scale of Business',
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
                  const Text('Small Business'),
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
                  const Text('Large Business'),
                ],
              ),

              const SizedBox(height: 20),

              // Proof of Business Section
              const Text(
                'Proof of Business',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Choose file:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic to upload files can be added here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Upload',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Uploaded Files with Delete Buttons
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: files.map((file) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            file['type'] == 'PDF'
                                ? Icons.picture_as_pdf
                                : Icons.image,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(file['name']!)),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                files.remove(file); // Logic to delete file
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Row(
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

              const SizedBox(height: 10),

              // Note Section
              const Text(
                'Note: Wait for 7-10 business days for the approval and verification',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ),

              const SizedBox(height: 30),
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
              const SizedBox(height: 5),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Please agree to the Privacy Policy and Terms to continue.',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 30),

              Center(
                child: isLoading
                    ? const CircularProgressIndicator() // Show loading spinner
                    : Container(
                        decoration: BoxDecoration(
                          color: (isPrivacyChecked &&
                                  isTermsChecked &&
                                  allFieldsFilled)
                              ? const Color(0xFF662C2B)
                              : Colors.grey,
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
                          onPressed: (isPrivacyChecked &&
                                  isTermsChecked &&
                                  allFieldsFilled)
                              ? () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    // Call the registerClient function from the Authentication controller
                                    await authController.registerCreative(
                                        businessEmailController.text,
                                        businessNameController.text,
                                        unitNumberController.text,
                                        streetController.text,
                                        villageController.text,
                                        barangayController.text,
                                        cityController.text,
                                        provinceController.text,
                                        businessPhoneNumberController.text,
                                        context);
                                  } catch (e) {
                                    // ignore: avoid_print
                                    print('Error during registration: $e');
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              : null,
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
  Widget buildTextField(String label, {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
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

  Widget buildCheckbox(BuildContext context, String text, String linkText,
      bool isChecked, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: text,
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: linkText,
                    style: const TextStyle(color: Colors.blue),
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
