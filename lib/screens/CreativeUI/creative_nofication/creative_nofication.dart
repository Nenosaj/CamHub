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
  Set<String> processingAppointments = {}; // Track appointments in progress

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("No user authenticated.");
        return [];
      }

      // Query Firestore for appointments with matching creativeId
      QuerySnapshot appointmentsSnapshot = await _firestore
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
    setState(() {
      processingAppointments.add(appointmentId);
    });

    try {
      DocumentReference appointmentRef =
          _firestore.collection('appointments').doc(appointmentId);

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

      await _firestore.collection('bookings').add(bookingDetails);

      print('Appointment approved and added to bookings.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment approved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error approving appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to approve appointment.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        processingAppointments.remove(appointmentId);
      });
    }
  }

  Future<void> declineAppointment(String appointmentId, String reason) async {
    setState(() {
      processingAppointments.add(appointmentId);
    });

    try {
      DocumentReference appointmentRef =
          _firestore.collection('appointments').doc(appointmentId);

      DocumentSnapshot appointmentSnapshot = await appointmentRef.get();

      if (!appointmentSnapshot.exists) {
        print("Appointment document does not exist.");
        return;
      }

      await appointmentRef.update({
        'approved': false,
        'declined': true,
        'reason': reason.isNotEmpty ? reason : 'No reason provided',
      });

      print('Appointment declined with reason: $reason');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment declined successfully!'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      print('Error declining appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to decline appointment.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        processingAppointments.remove(appointmentId);
      });
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    setState(() {
      processingAppointments.add(appointmentId);
    });

    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
      print('Appointment deleted successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment deleted successfully!'),
          backgroundColor: Colors.grey,
        ),
      );
      setState(() {}); // Refresh the UI
    } catch (e) {
      print('Error deleting appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete appointment.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        processingAppointments.remove(appointmentId);
      });
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
                Navigator.pop(context);
                declineAppointment(appointmentId, reasonController.text.trim());
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
                      if (appointment['approved'] == true ||
                          appointment['declined'] == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment['approved'] == true
                                  ? "Status: Approved ✅"
                                  : "Status: Declined ❌\nReason: ${appointment['reason']}",
                              style: TextStyle(
                                color: appointment['approved'] == true
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed:
                                  processingAppointments.contains(appointmentId)
                                      ? null
                                      : () => deleteAppointment(appointmentId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.black,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed:
                                  processingAppointments.contains(appointmentId)
                                      ? null
                                      : () => approveAppointment(appointmentId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.black,
                              ),
                              child: const Text("Approve"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed:
                                  processingAppointments.contains(appointmentId)
                                      ? null
                                      : () => _showDeclineDialog(appointmentId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.black,
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
