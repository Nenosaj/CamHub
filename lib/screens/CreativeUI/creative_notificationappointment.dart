import 'package:flutter/material.dart';

class CreativeNotificationAppointment extends StatefulWidget {
  final String clientName;
  final String contactNumber;
  final String message;
  final String eventTitle;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String packageName;
  final List<String> services;

  const CreativeNotificationAppointment({
    super.key,
    required this.clientName,
    required this.contactNumber,
    required this.message,
    required this.eventTitle,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.packageName,
    required this.services,
  });

  @override
  _CreativeNotificationAppointmentState createState() => _CreativeNotificationAppointmentState();
}

class _CreativeNotificationAppointmentState extends State<CreativeNotificationAppointment> {
  bool isConfirmed = false;
  bool isDeclined = false;

  // Function to show decline confirmation dialog
  void _showDeclineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Decline Appointment'),
          content: const Text('Are you sure you want to decline the appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isDeclined = true; // Update the state to reflect the decline
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Decline'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle confirmation of the appointment
  void _confirmAppointment() {
    setState(() {
      isConfirmed = true; // Update the state to reflect the confirmation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        toolbarHeight: 80.0,
        title: const Text('Appointment Request', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Back navigation
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage('assets/images/company_logo.png'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Higala Films', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(widget.clientName, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Contact Information'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.black54),
                const SizedBox(width: 8),
                Text(widget.contactNumber, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.message, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(widget.message, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Date and Address'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.event, color: Colors.black54),
                const SizedBox(width: 8),
                Text(widget.eventTitle, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.black54),
                const SizedBox(width: 8),
                Text('${widget.eventDate}  •  ${widget.eventTime}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black54),
                const SizedBox(width: 8),
                Text(widget.eventLocation, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Selection'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.inventory_2, color: Colors.black54),
                const SizedBox(width: 8),
                Text(widget.packageName, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            ...widget.services.map((service) => Row(
              children: [
                const Icon(Icons.add, color: Colors.black54),
                const SizedBox(width: 8),
                Text(service, style: const TextStyle(fontSize: 16)),
              ],
            )),
            const Spacer(), // Pushes buttons to the bottom
            if (!isConfirmed && !isDeclined) // Only show buttons if not confirmed/declined
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: _confirmAppointment, // Confirm button handler
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF662C2B),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _showDeclineDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF662C2B),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (isConfirmed)
              const Center(
                child: Text(
                  'Appointment Confirmed!',
                  style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            if (isDeclined)
              const Center(
                child: Text(
                  'Appointment Declined!',
                  style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper to create section headers
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
