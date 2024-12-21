import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'client_message.dart'; // Import the ChatScreen
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => UserListScreenState();
}

class UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> creatives = [];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    _fetchCreatives();
  }

  Future<void> _getCurrentUserId() async {
    User? user = _auth.currentUser;
    setState(() {
      currentUserId = user?.uid;
    });
  }

  Future<void> _fetchCreatives() async {
    try {
      // Fetch creatives from the `creatives` collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('creatives').get();

      List<Map<String, dynamic>> fetchedCreatives = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID as the creative ID
        return data;
      }).toList();

      setState(() {
        creatives = fetchedCreatives;
      });
    } catch (e) {
      print('Error fetching creatives: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Creative'),
        backgroundColor: const Color(0xFF662C2B),
      ),
      body: currentUserId == null
          ? const Center(child: CircularProgressIndicator())
          : creatives.isEmpty
              ? const Center(child: Text('No creatives available'))
              : ListView.builder(
                  itemCount: creatives.length,
                  itemBuilder: (context, index) {
                    final creative = creatives[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: creative['profilePicture'] != null
                            ? NetworkImage(creative['profilePicture'])
                            : const AssetImage(
                                    'assets/images/default_profile.png')
                                as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                      title:
                          Text(creative['businessName'] ?? 'Unnamed Creative'),
                      subtitle: Text(
                          creative['businessPhoneNumber'] ?? 'No Phone Number'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              photographerName:
                                  creative['businessName'] ?? 'Unknown',
                              senderClientId:
                                  currentUserId ?? 'unknownClientId',
                              recipientCreativeId: creative['id'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
