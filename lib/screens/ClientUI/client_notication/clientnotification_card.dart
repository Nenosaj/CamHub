import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: const Color(0xFF662C2B), // Maroon color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.white),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (buttonText != null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF662C2B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(buttonText!),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
