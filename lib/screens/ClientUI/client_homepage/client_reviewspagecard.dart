import 'package:flutter/material.dart';

class ReviewPageCard extends StatelessWidget {
  final String avatar;
  final String name;
  final double rating;
  final String package;
  final String review;

  const ReviewPageCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.rating,
    required this.package,
    required this.review,
  });

  static List<Map<String, dynamic>> reviews = [
    {
      'avatar': 'assets/avatar1.png', // Replace with your avatar asset
      'name': 'Christian James E. Apuya',
      'rating': 4.8,
      'package': 'Package 4',
      'review':
          'The package was a great deal, it is affordable and a beautiful package.',
    },
    {
      'avatar': 'assets/avatar2.png',
      'name': 'Hugo James Okit',
      'rating': 4.8,
      'package': 'Package 1',
      'review':
          'The package was a great deal, it is affordable and a beautiful package.',
    },
    {
      'avatar': 'assets/avatar3.png',
      'name': 'Jason Daohog',
      'rating': 4.8,
      'package': 'Package 7',
      'review':
          'The package was a great deal, it is affordable and a beautiful package.',
    },
    {
      'avatar': 'assets/avatar4.png',
      'name': 'Czarleign Mae Balucos',
      'rating': 4.8,
      'package': 'Package 3',
      'review':
          'The package was a great deal, it is affordable and a beautiful package.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage(avatar), // Replace with your avatar asset
              radius: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name of the reviewer
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Rating and Package under the name
                  Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFF662C2B), size: 16),
                      SizedBox(width: 5),
                      Text('$rating'),
                      SizedBox(width: 10),
                      Text('Package: $package'),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Review text
                  Text(review),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
