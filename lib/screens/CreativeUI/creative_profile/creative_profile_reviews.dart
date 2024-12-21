import 'package:flutter/material.dart';

class CreativeReviews extends StatelessWidget {
  const CreativeReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text(
          'Reviews',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchReviews(), // Simulating fetching reviews
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load reviews. Please try again later.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No reviews yet',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          } else {
            final reviews = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _buildReviewCard(review);
              },
            );
          }
        },
      ),
    );
  }

  // Simulating fetching reviews
  Future<List<Map<String, dynamic>>> _fetchReviews() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return [
      {
        'clientName': 'John Doe',
        'reviewText': 'Amazing service! Highly recommend.',
        'rating': 5,
        'date': '2024-12-21',
      },
      {
        'clientName': 'Jane Smith',
        'reviewText': 'The team was professional and the output was great.',
        'rating': 4,
        'date': '2024-12-20',
      },
    ];
  }

  // Widget to display individual review cards
  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 40, color: Color(0xFF662C2B)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['clientName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF662C2B),
                      ),
                    ),
                    Text(
                      review['date'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              review['reviewText'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(
                review['rating'],
                (index) =>
                    const Icon(Icons.star, color: Colors.amber, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
