import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF662C2B), // Maroon color for the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pop(context); // Go back when pressed
          },
        ),
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0), // Aligns the search text
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF662C2B), // Maroon color
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildCategoryItem(Icons.cake, 'Anniversary'),
                  _buildCategoryItem(Icons.favorite, 'Weddings'),
                  _buildCategoryItem(Icons.cake, 'Birthdays'),
                  _buildCategoryItem(Icons.child_care, 'Christening'),
                  _buildCategoryItem(Icons.favorite, 'Engagement'),
                  _buildCategoryItem(Icons.school, 'Graduation'),
                  _buildCategoryItem(Icons.sports_basketball, 'Sports'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Add functionality for 'See More'
              },
              child: Text(
                'See More',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each category item
  Widget _buildCategoryItem(IconData icon, String label) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(label),
        onTap: () {
          // Add onTap functionality to navigate or filter by category
        },
      ),
    );
  }
}
