import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreativeNotificationPage extends StatefulWidget {
  const CreativeNotificationPage({super.key});

  @override
  State<CreativeNotificationPage> createState() =>
      _CreativeNotificationPageState();
}

class _CreativeNotificationPageState extends State<CreativeNotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch appointments specific to the current creative user
  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    List<Map<String, dynamic>> appointments = [];

    try {
      // Step 1: Get the current authenticated creative's UID
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("No creative user is logged in.");
        return [];
      }
      String creativeId = currentUser.uid;

      // Step 2: Access 'uploads' subcollection under the current creative's document
      QuerySnapshot uploadsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(creativeId) // Parent: creative's document ID
          .collection('uploads') // Subcollection: 'uploads'
          .get();

      // Step 3: Extract appointment data
      for (QueryDocumentSnapshot appointmentDoc in uploadsSnapshot.docs) {
        Map<String, dynamic> appointmentData =
            appointmentDoc.data() as Map<String, dynamic>;

        // Include identifiers for clarity
        appointmentData['creativeId'] = creativeId; // Creative's ID
        appointmentData['appointmentId'] = appointmentDoc.id; // Document ID

        appointments.add(appointmentData);
      }

      print('Fetched Appointments: ${appointments.length}');
      return appointments;
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Approve an appointment and create a booking in the "bookings" collection
  Future<void> approveAppointment(String creativeId, String uploadId) async {
    try {
      // Reference the appointment document
      DocumentReference appointmentRef = _firestore
          .collection('appointments')
          .doc(creativeId)
          .collection('uploads')
          .doc(uploadId);

      // Fetch the appointment data
      DocumentSnapshot appointmentSnapshot = await appointmentRef.get();
      if (!appointmentSnapshot.exists) {
        print("Appointment document does not exist.");
        return;
      }

      // Safely access data with null checks and defaults
      Map<String, dynamic> appointmentData =
          (appointmentSnapshot.data() as Map<String, dynamic>?) ?? {};

      final safeAppointmentData = {
        'clientId': appointmentData['clientId'] ?? 'No Client ID',
        'fullName': appointmentData['fullName'] ?? 'No Name',
        'eventType': appointmentData['eventType'] ?? 'No Event Type',
        'packageName': appointmentData['packageName'] ?? 'No Package',
        'packagePrice': appointmentData['packagePrice'] ?? '₱0',
        'address': appointmentData['address'] ?? 'No Address',
        'date': appointmentData['date'] ?? 'N/A',
        'time': appointmentData['time'] ?? 'N/A',
        'totalCost': appointmentData['totalCost'] ?? 0,
        'addOns': appointmentData['addOns'] != null
            ? List<Map<String, dynamic>>.from(appointmentData['addOns'])
            : [], // Ensure addOns is a list
        'approved': true,
        'declined': false,
        'reason': null, // Default empty reason
      };

      // Step 1: Update the approved status
      await appointmentRef.update({
        'approved': true,
        'declined': false,
      });

      // Step 2: Add the validated data to the 'bookings' collection
      await _firestore
          .collection('bookings')
          .doc(creativeId) // Use creative ID as parent
          .collection('uploads')
          .add({
        'bookingDetails': safeAppointmentData,
      });

      print('Booking successfully created: $safeAppointmentData');
      setState(() {}); // Refresh UI
    } catch (e) {
      print('Error approving appointment: $e');
    }
  }

  // Decline an appointment
  Future<void> declineAppointment(
      String creativeId, String appointmentId, String reason) async {
    try {
      // Reference the appointment document
      DocumentReference appointmentRef = _firestore
          .collection('appointments')
          .doc(creativeId)
          .collection('uploads')
          .doc(appointmentId);

      // Update the decline status safely
      await appointmentRef.update({
        'approved': false,
        'declined': true,
        'reason': reason.isNotEmpty ? reason : 'No reason provided',
      });

      print('Appointment declined successfully with reason: $reason');
      setState(() {}); // Refresh UI
    } catch (e) {
      print('Error declining appointment: $e');
    }
  }

  void _showDeclineDialog(String creativeId, String appointmentId) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Decline Appointment"),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: "Reason for Decline",
              hintText: "Enter reason here",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                declineAppointment(
                    creativeId, appointmentId, reasonController.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text(
          'Appointments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchAppointments(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No appointments available."));
          }

          final appointments = snapshot.data!;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final creativeId = appointment['creativeId'];
              final uploadId = appointment['appointmentId'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client: ${appointment['fullName']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Event Type: ${appointment['eventType']}'),
                      Text('Event Date: ${appointment['date']}'),
                      Text('Event Time: ${appointment['time']}'),
                      Text('Location: ${appointment['address']}'),
                      Text('Package: ${appointment['packageName']}'),
                      const SizedBox(height: 8),

                      // Add-ons
                      if (appointment['addOns'] != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Add-ons:"),
                            ...(appointment['addOns'] as List<dynamic>).map(
                                (addon) => Text(
                                    '• ${addon['addOn']} (₱${addon['price']})')),
                          ],
                        ),

                      const SizedBox(height: 8),
                      // Approve/Decline Status
                      if (appointment['approved'] == true)
                        const Text(
                          "Status: Approved ✅",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      else if (appointment['declined'] == true)
                        Text(
                          "Status: Declined ❌\nReason: ${appointment['reason']}",
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      else
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  approveAppointment(creativeId, uploadId),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text("Approve"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () =>
                                  _showDeclineDialog(creativeId, uploadId),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text("Decline"),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
