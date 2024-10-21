/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:example/screens/registration/credentials_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FillUpPageCreatives extends StatefulWidget {
  const FillUpPageCreatives({super.key});

  @override
  FillUpPageCreativesState createState() => FillUpPageCreativesState();
}

class FillUpPageCreativesState extends State<FillUpPageCreatives> {

  final FirebaseAuth _auth = FirebaseAuth.instance; // for Firebase authentication



  bool isPrivacyChecked = false; // For first checkbox
  bool isTermsChecked = false; // For second checkbox
  bool showError =
      false; // Flag to show error message if checkboxes are not ticked

  // Variables to store the form values
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String birthday = '';
  String unitNumber = '';
  String street = '';
  String village = '';
  String barangay = '';
  String city = '';
  String province = '';
  String email = '';
  String phoneNumber = '';

  // TextEditingControllers for all input fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController barangayController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool allFieldsFilled = false; // To track if all fields are filled


Future<void> registerClient(String email) async {
  try {
    // Create the user with a temporary password
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: 'TemporaryPassword123', // Temporary password
    );

    // Instead of sending OTP, directly navigate to SetPassword
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CredentialsUpload(email: email),
      ),
    );
  } catch (e) {
    print(e); // Handle errors such as email already in use
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration failed: $e')),
    );
  }
}


  @override
  void initState() {
    super.initState();
    _addValidationListeners();
  }

  // Add listeners to controllers to validate fields and update variables
  void _addValidationListeners() {
    firstNameController
        .addListener(() => _updateField('firstName', firstNameController.text));
    middleNameController.addListener(
        () => _updateField('middleName', middleNameController.text));
    lastNameController
        .addListener(() => _updateField('lastName', lastNameController.text));
    birthdayController
        .addListener(() => _updateField('birthday', birthdayController.text));
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
    emailController
        .addListener(() => _updateField('email', emailController.text));
    phoneNumberController.addListener(
        () => _updateField('phoneNumber', phoneNumberController.text));
  }

  // Method to update the corresponding variable when text changes
  void _updateField(String field, String value) {
    setState(() {
      switch (field) {
        case 'firstName':
          firstName = value;
          break;
        case 'middleName':
          middleName = value;
          break;
        case 'lastName':
          lastName = value;
          break;
        case 'birthday':
          birthday = value;
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
        case 'email':
          email = value;
          break;
        case 'phoneNumber':
          phoneNumber = value;
          break;
      }
      _validateFields();
    });
  }

  // Validate if all fields are filled
  void _validateFields() {
    setState(() {
      allFieldsFilled = firstName.isNotEmpty &&
          middleName.isNotEmpty &&
          lastName.isNotEmpty &&
          birthday.isNotEmpty &&
          unitNumber.isNotEmpty &&
          street.isNotEmpty &&
          village.isNotEmpty &&
          barangay.isNotEmpty &&
          city.isNotEmpty &&
          province.isNotEmpty &&
          email.isNotEmpty &&
          phoneNumber.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    birthdayController.dispose();
    unitNumberController.dispose();
    streetController.dispose();
    villageController.dispose();
    barangayController.dispose();
    cityController.dispose();
    provinceController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        color: Colors.white, // Set the background color to plain white
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField('First Name', controller: firstNameController),
                buildTextField('Middle Name', controller: middleNameController),
                buildTextField('Last Name', controller: lastNameController),
                buildTextField('Birthday',
                    isDateField: true, controller: birthdayController),
                buildTextField('Unit No./House No./Building Number',
                    controller: unitNumberController),
                buildTextField('Street', controller: streetController),
                buildTextField('Village/Subdivision',
                    controller: villageController),
                buildTextField('Barangay', controller: barangayController),
                buildTextField('City', controller: cityController),
                buildTextField('Province', controller: provinceController),
                buildTextField('Email', controller: emailController),
                buildTextField('Phone Number',
                    controller: phoneNumberController),
                const SizedBox(height: 20),
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
                  child: Container(
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
                          offset: const Offset(0, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: (isPrivacyChecked &&
                              isTermsChecked &&
                              allFieldsFilled)
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         CredentialsUpload(
                                          email: emailController.text,

                                        )
                                    ),
                              );
                            }
                          : null, // Disable the button if conditions are not met
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
      ),
    );
  }

  // Helper method to create a TextField with the label and controller
  Widget buildTextField(String label,
      {bool isDateField = false, TextEditingController? controller}) {
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
            readOnly: isDateField,
            onTap: isDateField ? () => _selectDate(context, controller!) : null,
            decoration: InputDecoration(
              hintText: isDateField ? 'Choose Date' : 'Enter Here',
              suffixIcon: isDateField
                  ? const Icon(Icons.calendar_today, color: Colors.grey)
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

  // Method to show date picker and set selected date to the TextField
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        controller.text = formattedDate;
        birthday = formattedDate;
      });
    }
  }

  // Helper method to create a checkbox with text and a link
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
*/