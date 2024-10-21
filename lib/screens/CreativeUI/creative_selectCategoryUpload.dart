import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  final Function(String) onCategorySelected;

  const SelectCategory({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  String? _selectedCategory; // To store the currently selected category

  @override
  Widget build(BuildContext context) {
    // Define categories and icons for each
    List<Map<String, dynamic>> categories = [
      {'label': 'Weddings', 'icon': Icons.favorite},
      {'label': 'Birthdays', 'icon': Icons.cake},
      {'label': 'Anniversary', 'icon': Icons.card_giftcard},
      {'label': 'Graduation', 'icon': Icons.school},
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: const Color(0xFF7B3A3F), // Maroon background
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjusts height dynamically
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Category Buttons with Icons
            ListView.builder(
              shrinkWrap: true, // Allows the list to take up only needed space
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildCategoryButton(
                    context,
                    label: categories[index]['label'],
                    icon: categories[index]['icon'],
                    isSelected: _selectedCategory == categories[index]['label'],
                    onTap: () {
                      setState(() {
                        _selectedCategory = categories[index]['label'];
                      });
                      widget.onCategorySelected(categories[index]['label']);
                      Navigator.of(context).pop(); // Return selection
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Updated function to include icon parameter and selection indicator
  Widget _buildCategoryButton(BuildContext context,
      {required String label,
      required IconData icon,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFB1635B)
              : Colors.white, // Highlight selected category
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3), blurRadius: 5.0)
                ]
              : [], // Add shadow to selected category
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10), // Space for padding
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF7B3A3F), // Change icon color if selected
            ),
            const SizedBox(width: 10), // Space between icon and text
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF7B3A3F), // Change text color if selected
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
