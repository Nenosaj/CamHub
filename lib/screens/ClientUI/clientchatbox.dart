import 'package:flutter/material.dart';

class ClientChatBox extends StatelessWidget {
  final String message;
  final String time;

  const ClientChatBox({super.key, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Align(
        alignment: Alignment.centerLeft, // Aligns the chat box to the left
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8), // Makes the chat box wider
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 233, 153, 152), // Lighter maroon shade
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  color: Color.fromARGB(221, 8, 8, 8),
                  fontSize: 16,
                ), // Adjust text color and size
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: const TextStyle(
                  color: Color.fromARGB(255, 87, 83, 83),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
