import 'package:example/screens/CreativeUI/creative_AccountsMessaged.dart';
import 'package:flutter/material.dart';
import 'creativemessagesearchbar.dart';  // Import the search bar logic

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreativeChatScreen(clientName: '', messages: []),
    );
  }
}

class CreativeChatScreen extends StatefulWidget {
  final String clientName;
  final List messages;

  const CreativeChatScreen({super.key, required this.clientName, required this.messages});

  @override
  CreativeChatScreenState createState() => CreativeChatScreenState();
}

class CreativeChatScreenState extends State<CreativeChatScreen> {
  String searchText = ""; // Track the search input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220), // Keep the original height
        child: AppBar(
          backgroundColor: const Color(0xFF662C2B), // Keep the AppBar design
          title: const Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              'Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(50, 100.0, 50, 50),
            child: Column(
              children: [
                Container(
                  height: 50, // Keep the search bar size
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 18),
                      prefixIcon: Icon(Icons.search, size: 18),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value.trim().toLowerCase(); // Update search text dynamically
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          searchText.isEmpty
              ? const CreativeAccountsMessaged() // Show the full conversation list when no search query
              : Positioned(
                  top: 0, // Bring the dropdown right below the search bar
                  left: 15, // Align the search results with the search bar
                  right: 15, // Ensure the search results stay within bounds
                  child: Material(
                    elevation: 2.0, // Add slight shadow for the dropdown
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // White background for the search results
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: _getDropdownHeight(), // Dynamically adjust based on content
                      ),
                      child: CreativeSearchUserResults(searchText: searchText), // Use the search bar logic
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Dynamically calculate the dropdown height based on the number of results
  double _getDropdownHeight() {
    int resultsCount = CreativeSearchUserResults(searchText: searchText).getResultsCount();
    return (resultsCount * 60.0).clamp(0.0, 300.0); // Each item is ~60px, limit to 300px
  }
}
