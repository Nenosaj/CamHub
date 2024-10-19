import 'package:example/screens/ClientUI/clientmessaging.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220), // Adjusted height to match the screenshot
        child: AppBar(
          backgroundColor: const Color(0xFF662C2B),
          title: const Padding(
            padding: EdgeInsets.only(top: 30.0), // Adjust for better centering of the title
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
            padding: const EdgeInsets.fromLTRB(50, 100.0, 50, 50), // Adjust positioning of the search bar
            child: Container(
              height: 50, // Adjusted height for the search bar
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
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(fontSize: 18),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: const EmptyChatScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchUserScreen()),
          );
        },
        backgroundColor: const Color(0xFF662C2B),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class EmptyChatScreen extends StatelessWidget {
  const EmptyChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // No additional search bar here since it's moved into the AppBar section.
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'No Messages',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// New screen for searching users
class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        backgroundColor: const Color(0xFF662C2B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for someone to message...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 20),
            if (searchText == "creative")
              GestureDetector(
                onTap: () {
                  print('Creative pressed');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessagingScreen(),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: const Text(
                    'Creative',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            if (searchText != "creative" && searchText.isNotEmpty)
              Expanded(
                child: Center(
                  child: const Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
