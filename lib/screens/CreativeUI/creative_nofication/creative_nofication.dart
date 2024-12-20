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

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("No user authenticated.");
        return [];
      }

      // Query Firestore for appointments with matching creativeId
      QuerySnapshot appointmentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('creativeId', isEqualTo: currentUser.uid)
          .get();

      // Parse the documents into a list of maps
      List<Map<String, dynamic>> appointments =
          appointmentsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['appointmentId'] = doc.id; // Add document ID
        return data;
      }).toList();

      print('Fetched ${appointments.length} appointments.');
      return appointments;
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  Future<void> approveAppointment(String appointmentId) async {
    try {
      DocumentReference appointmentRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId);

      DocumentSnapshot appointmentSnapshot = await appointmentRef.get();

      if (!appointmentSnapshot.exists) {
        print("Appointment document does not exist.");
        return;
      }

      Map<String, dynamic> appointmentData =
          (appointmentSnapshot.data() as Map<String, dynamic>?) ?? {};

      final bookingDetails = {
        'appointmentId': appointmentId,
        'clientId': appointmentData['clientId'] ?? '',
        'creativeId': appointmentData['creativeId'] ?? '',
        'packageId': appointmentData['packageId'] ?? '',
        'fullName': appointmentData['fullName'] ?? '',
        'eventType': appointmentData['eventType'] ?? '',
        'packageName': appointmentData['packageName'] ?? '',
        'packagePrice': appointmentData['packagePrice'] ?? 0,
        'address': appointmentData['address'] ?? '',
        'date': appointmentData['date'] ?? '',
        'time': appointmentData['time'] ?? '',
        'totalCost': appointmentData['totalCost'] ?? 0,
        'addOns': appointmentData['addOns'] ?? [],
        'approved': true,
        'declined': false,
        'createdAt': appointmentData['createdAt'] ?? Timestamp.now(),
      };

      await appointmentRef.update({
        'approved': true,
        'declined': false,
      });

      await FirebaseFirestore.instance
          .collection('bookings')
          .add(bookingDetails);

      print('Appointment approved and added to bookings.');
    } catch (e) {
      print('Error approving appointment: $e');
    }
  }

  Future<void> declineAppointment(String appointmentId, String reason) async {
    try {
      DocumentReference appointmentRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId);

      await appointmentRef.update({
        'approved': false,
        'declined': true,
        'reason': reason.isNotEmpty ? reason : 'No reason provided',
      });

      print('Appointment declined with reason: $reason');
    } catch (e) {
      print('Error declining appointment: $e');
    }
  }

  void _showDeclineDialog(String appointmentId) {
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
                declineAppointment(appointmentId, reasonController.text.trim());
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
              final appointmentId = appointment['appointmentId'];

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
                                  approveAppointment(appointmentId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green, // Button background color
                                foregroundColor: Colors.black, // Text color
                              ),
                              child: const Text("Approve"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () =>
                                  _showDeclineDialog(appointmentId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red, // Button background color
                                foregroundColor: Colors.black, // Text color
                              ),
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
