import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:example/screens/ClientUI/client_homepage/client_bookingconfirmation.dart';

class RequestSummary extends StatefulWidget {
  final String creativeuid;
  final String uuid;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String address;
  final Map<String, bool> selectedAddOns;
  final Map<String, String> addOnPrices;
  final int totalCost;
  final String packageName;
  final String packagePrice;
  final String eventType;

  const RequestSummary({
    super.key,
    required this.creativeuid,
    required this.uuid,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.selectedAddOns,
    required this.addOnPrices,
    required this.totalCost,
    required this.packageName,
    required this.packagePrice,
    required this.eventType,
  });

  @override
  State<RequestSummary> createState() => _RequestSummaryState();
}

class _RequestSummaryState extends State<RequestSummary> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Future<void> _saveToFirestore(BuildContext context) async {
    try {
      // Fetch the current authenticated user
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Check if the user is logged in
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated. Please log in again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Prepare selected add-ons
      List<Map<String, dynamic>> addOnsList = widget.selectedAddOns.entries
          .where((entry) => entry.value)
          .map((entry) => {
                'addOn': entry.key,
                'price': widget.addOnPrices[entry.key] ?? '₱0',
              })
          .toList();

      // Prepare data to store
      Map<String, dynamic> appointmentData = {
        'clientId': currentUser.uid, // Current user's ID
        'packageId': widget.uuid,
        'creativeId': widget.creativeuid,
        'packageName': widget.packageName,
        'packagePrice': widget.packagePrice,
        'eventType': widget.eventType,
        'date': DateFormat('yyyy-MM-dd').format(widget.selectedDate),
        'time': widget.selectedTime.format(context),
        'address': widget.address,
        'addOns': addOnsList,
        'totalCost': widget.totalCost,
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'notes': _notesController.text.trim(),
        'approved': false, // Default status
        'createdAt': Timestamp.now(),
      };

      // Firestore reference for the updated structure
      CollectionReference appointmentsRef =
          FirebaseFirestore.instance.collection('appointments');

      // Add the appointment data with an auto-generated document ID
      DocumentReference newAppointmentRef =
          await appointmentsRef.add(appointmentData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BookingConfirmation(),
        ),
      ); // Navigate back after submission
    } catch (e) {
      print('Error saving to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit appointment. Try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Review Request',
          style: TextStyle(color: Color(0xFF662C2B)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryTable(),
            const SizedBox(height: 20),
            _buildEventDetails(context),
            const SizedBox(height: 20),
            _buildContactForm(),
            const SizedBox(height: 20),
            _buildTotalCost(),
            const SizedBox(height: 20),
            const Text(
              "Information you provide will be shared with Higala Films as a message so they contact you. Furthermore, it is subject to their terms and policies, as well as CAMHUB's Data Policy.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selection Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.grey),
          children: [
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.packageName),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.packagePrice),
              ),
            ]),
            ...widget.selectedAddOns.entries.map((entry) {
              if (entry.value) {
                return TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(entry.key),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.addOnPrices[entry.key] ?? '₱0'),
                  ),
                ]);
              }
              return const TableRow(children: [SizedBox(), SizedBox()]);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.event),
            const SizedBox(width: 10),
            Text(DateFormat.yMMMMd().format(widget.selectedDate)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 10),
            Text(widget.selectedTime.format(context)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 10),
            Text(widget.address),
          ],
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Contact Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildTextField('Full Name', _fullNameController),
        const SizedBox(height: 10),
        _buildTextField('Phone Number (optional)', _phoneNumberController),
        const SizedBox(height: 10),
        _buildTextField('Add Notes (optional)', _notesController),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCost() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Cost:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '₱${widget.totalCost}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _saveToFirestore(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF662C2B),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Center(
        child: Text(
          'Submit Request',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
