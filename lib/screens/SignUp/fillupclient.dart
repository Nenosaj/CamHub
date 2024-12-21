import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:example/screens/Firebase/authentication.dart';

class FillUpPageClient extends StatefulWidget {
  const FillUpPageClient({super.key});

  @override
  FillUpPageClientState createState() => FillUpPageClientState();
}

class FillUpPageClientState extends State<FillUpPageClient> {
  final Authentication authController = Authentication();

  bool isPrivacyChecked = false;
  bool isTermsChecked = false;
  bool showError = false;

  // Form variables
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

  // Error messages
  String firstNameError = '';
  String middleNameError = '';
  String lastNameError = '';
  String birthdayError = '';
  String emailError = '';
  String phoneNumberError = '';

  // Track user interaction
  bool isFirstNameTouched = false;
  bool isMiddleNameTouched = false;
  bool isLastNameTouched = false;
  bool isBirthdayTouched = false;
  bool isEmailTouched = false;
  bool isPhoneNumberTouched = false;

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

  @override
  void initState() {
    super.initState();
  }

  void _validateFirstName() {
    setState(() {
      if (isFirstNameTouched) {
        firstName = firstNameController.text;
        firstNameError = firstName.isEmpty
            ? ''
            : RegExp(r'^[a-zA-Z ]+$').hasMatch(firstName)
                ? ''
                : 'Invalid first name. No special characters allowed.';
      }
    });
  }

  void _validateMiddleName() {
    setState(() {
      if (isMiddleNameTouched) {
        middleName = middleNameController.text;
        middleNameError = middleName.isEmpty
            ? ''
            : RegExp(r'^[a-zA-Z ]+$').hasMatch(middleName)
                ? ''
                : 'Invalid middle name. No special characters allowed.';
      }
    });
  }

  void _validateLastName() {
    setState(() {
      if (isLastNameTouched) {
        lastName = lastNameController.text;
        lastNameError = lastName.isEmpty
            ? ''
            : RegExp(r'^[a-zA-Z ]+$').hasMatch(lastName)
                ? ''
                : 'Invalid last name. No special characters allowed.';
      }
    });
  }

  void _validateBirthday() {
    setState(() {
      if (isBirthdayTouched) {
        birthday = birthdayController.text;
        if (birthday.isNotEmpty) {
          DateTime? birthDate = DateTime.tryParse(birthday);
          if (birthDate == null ||
              birthDate.isAfter(
                  DateTime.now().subtract(const Duration(days: 6570)))) {
            birthdayError = 'Invalid date. You must be at least 18 years old.';
          } else {
            birthdayError = '';
          }
        } else {
          birthdayError = '';
        }
      }
    });
  }

  void _validateEmail() {
    setState(() {
      if (isEmailTouched) {
        email = emailController.text;
        emailError = email.isEmpty
            ? ''
            : RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                    .hasMatch(email)
                ? ''
                : 'Invalid email address. Please enter a valid email.';
      }
    });
  }

  void _validatePhoneNumber() {
    setState(() {
      if (isPhoneNumberTouched) {
        phoneNumber = phoneNumberController.text;
        phoneNumberError = phoneNumber.isEmpty
            ? ''
            : RegExp(r'^09\d{9}$').hasMatch(phoneNumber)
                ? ''
                : 'Invalid phone number. It must start with 09 and be 11 digits long.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF662C2B),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: AppBar(
            title: const Text('Create New Account',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                    'First Name', firstNameController, firstNameError, () {
                  setState(() {
                    isFirstNameTouched = true;
                  });
                  _validateFirstName();
                }),
                buildTextField(
                    'Middle Name', middleNameController, middleNameError, () {
                  setState(() {
                    isMiddleNameTouched = true;
                  });
                  _validateMiddleName();
                }),
                buildTextField('Last Name', lastNameController, lastNameError,
                    () {
                  setState(() {
                    isLastNameTouched = true;
                  });
                  _validateLastName();
                }),
                buildTextField('Birthday', birthdayController, birthdayError,
                    () {
                  setState(() {
                    isBirthdayTouched = true;
                  });
                  _validateBirthday();
                }, isDateField: true),
                buildTextField('Unit No./House No./Building Number',
                    unitNumberController, '', () {}),
                buildTextField('Street', streetController, '', () {}),
                buildTextField(
                    'Village/Subdivision', villageController, '', () {}),
                buildTextField('Barangay', barangayController, '', () {}),
                buildTextField('City', cityController, '', () {}),
                buildTextField('Province', provinceController, '', () {}),
                buildTextField('Email', emailController, emailError, () {
                  setState(() {
                    isEmailTouched = true;
                  });
                  _validateEmail();
                }),
                buildTextField(
                    'Phone Number', phoneNumberController, phoneNumberError,
                    () {
                  setState(() {
                    isPhoneNumberTouched = true;
                  });
                  _validatePhoneNumber();
                }),
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
                              firstNameError.isEmpty &&
                              middleNameError.isEmpty &&
                              lastNameError.isEmpty &&
                              birthdayError.isEmpty &&
                              emailError.isEmpty &&
                              phoneNumberError.isEmpty)
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
                              firstNameError.isEmpty &&
                              middleNameError.isEmpty &&
                              lastNameError.isEmpty &&
                              birthdayError.isEmpty &&
                              emailError.isEmpty &&
                              phoneNumberError.isEmpty)
                          ? () async {
                              try {
                                await authController.registerClient(
                                    emailController.text,
                                    firstNameController.text,
                                    middleNameController.text,
                                    lastNameController.text,
                                    birthdayController.text,
                                    unitNumberController.text,
                                    streetController.text,
                                    villageController.text,
                                    barangayController.text,
                                    cityController.text,
                                    provinceController.text,
                                    phoneNumberController.text,
                                    context);
                              } catch (e) {
                                print('Error during registration: $e');
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
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      String error, Function()? onFocusLost,
      {bool isDateField = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus && onFocusLost != null) {
                onFocusLost();
              }
            },
            child: TextField(
              controller: controller,
              onChanged: (value) {
                if (label == 'First Name') _validateFirstName();
                if (label == 'Middle Name') _validateMiddleName();
                if (label == 'Last Name') _validateLastName();
                if (label == 'Email') _validateEmail();
                if (label == 'Phone Number') _validatePhoneNumber();
              },
              readOnly: isDateField,
              onTap: isDateField ? () => _selectDate(context) : null,
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
              keyboardType: label == 'Phone Number'
                  ? TextInputType.number
                  : TextInputType.text,
            ),
          ),
          if (error.isNotEmpty && controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(error,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime(2005),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        birthdayController.text = formattedDate;
        birthday = formattedDate;
        _validateBirthday();
      });
    }
  }
}
