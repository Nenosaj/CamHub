import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:example/screens/Firebase/authentication.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'autocomplete_address/geoapify_address.dart'; // Import the Geoapify API file

class FillUpPageClient extends StatefulWidget {
  const FillUpPageClient({super.key});

  @override
  FillUpPageClientState createState() => FillUpPageClientState();
}

class FillUpPageClientState extends State<FillUpPageClient> {
  final Authentication authController = Authentication();

  bool isPrivacyChecked = false; // For first checkbox
  bool isTermsChecked = false; // For second checkbox
  bool showError = false; // Show error if checkboxes are not ticked

  // TextEditingControllers for the text fields
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
  TextEditingController countryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        birthdayController.text = formattedDate;
      });
    }
  }

  // Debounced API call to prevent rapid requests
  Future<List<String>> debounceSuggestions(String query) async {
    await Future.delayed(const Duration(milliseconds: 300)); // 300ms delay
    return await fetchAddressSuggestions(query);
  }

  // Widget for Address Autocomplete Field
  Widget buildAddressAutocompleteField(
      String label, TextEditingController controller) {
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
          TypeAheadField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Start typing...',
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            controller.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            suggestionsCallback: debounceSuggestions, // Use debounced API call
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                controller.text = suggestion; // Set the selected suggestion
              });
            },
            noItemsFoundBuilder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No suggestions found.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            title: const Text(
              'Create New Account',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
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
                buildTextField('First Name', firstNameController),
                buildTextField('Middle Name', middleNameController),
                buildTextField('Last Name', lastNameController),
                buildTextField('Birthday', birthdayController,
                    isDateField: true),
                buildAddressAutocompleteField(
                    'Country', countryController), // Country Autocomplete
                buildAddressAutocompleteField('Province', provinceController),
                buildAddressAutocompleteField('City', cityController),
                buildAddressAutocompleteField('Barangay', barangayController),
                buildAddressAutocompleteField('Street', streetController),
                buildTextField(
                    'Unit No./House No./Building Number', unitNumberController),
                buildTextField('Email', emailController),
                buildTextField('Phone Number', phoneNumberController),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for standard TextFields
  Widget buildTextField(String label, TextEditingController controller,
      {bool isDateField = false}) {
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
            onTap: isDateField ? () => _selectDate(context) : null,
            decoration: InputDecoration(
              hintText: isDateField ? 'Choose Date' : 'Enter Here',
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
