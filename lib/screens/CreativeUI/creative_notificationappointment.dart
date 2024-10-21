import 'package:flutter/material.dart';

class CreativeNotificationAppointment extends StatelessWidget {
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
                  backgroundImage: AssetImage('assets/images/company_logo.png'), // Example placeholder for logo
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Higala Films', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(clientName, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Contact Information Section
            _buildSectionHeader('Contact Information'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.black54),
                const SizedBox(width: 8),
                Text(contactNumber, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.message, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(message, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Date and Address Section
            _buildSectionHeader('Date and Address'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.event, color: Colors.black54),
                const SizedBox(width: 8),
                Text(eventTitle, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.black54),
                const SizedBox(width: 8),
                Text('$eventDate  •  $eventTime', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black54),
                const SizedBox(width: 8),
                Text(eventLocation, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            // Selection Section
            _buildSectionHeader('Selection'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.inventory_2, color: Colors.black54),
                const SizedBox(width: 8),
                Text(packageName, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            ...services.map((service) => Row(
              children: [
                const Icon(Icons.add, color: Colors.black54),
                const SizedBox(width: 8),
                Text(service, style: const TextStyle(fontSize: 16)),
              ],
            )),
            const SizedBox(height: 20),
            // Confirm and Decline buttons
            const Spacer(), // Pushes buttons to the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle confirm functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF662C2B),
                        padding: const EdgeInsets.symmetric(vertical: 18), // Adjust button height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners for a more modern look
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
                        // Handle decline functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF662C2B),
                        padding: const EdgeInsets.symmetric(vertical: 18), // Adjust button height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners for a more modern look
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
            const SizedBox(height: 20), // Adds space at the bottom for comfort
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
