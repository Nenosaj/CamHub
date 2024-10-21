import 'package:flutter/material.dart';
import 'client_reviewsPageCard.dart'; // Import the ReviewPageCard class

class ReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Reviews & Ratings',
          style: TextStyle(color: Color(0xFF662C2B)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () => Navigator.of(context).pop(),
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
                  backgroundImage: AssetImage(
                      'assets/images/higala_logo.png'), // Replace with your logo asset
                  radius: 30,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Higala Films',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Ratings and Reviews',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFF662C2B), size: 16),
                        SizedBox(width: 5),
                        Text('4.3'),
                        SizedBox(width: 5),
                        Text('1000+ ratings'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: ReviewPageCard.reviews.length,
                itemBuilder: (context, index) {
                  var review = ReviewPageCard.reviews[index];
                  return ReviewPageCard(
                    avatar: review['avatar'],
                    name: review['name'],
                    rating: review['rating'],
                    package: review['package'],
                    review: review['review'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReviewsPage(),
  ));
}
