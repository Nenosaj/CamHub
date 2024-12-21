import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'creative_message.dart'; // Import the ChatScreen for creatives
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => UserListScreenState();
}

class UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> clients = [];
  String? currentCreativeId;

  @override
  void initState() {
    super.initState();
    _getCurrentCreativeId();
    _fetchClients();
  }

  Future<void> _getCurrentCreativeId() async {
    User? user = _auth.currentUser;
    setState(() {
      currentCreativeId = user?.uid;
    });
  }

  Future<void> _fetchClients() async {
    try {
      // Fetch clients from the `clients` collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('clients').get();

      List<Map<String, dynamic>> fetchedClients = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID as the client ID
        return data;
      }).toList();

      setState(() {
        clients = fetchedClients;
      });
    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Client'),
        backgroundColor: const Color(0xFF662C2B),
      ),
      body: currentCreativeId == null
          ? const Center(child: CircularProgressIndicator())
          : clients.isEmpty
              ? const Center(child: Text('No clients available'))
              : ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: client['profilePicture'] != null
                            ? NetworkImage(client['profilePicture'])
                            : const AssetImage(
                                    'assets/images/default_profile.png')
                                as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                      title: Text(
                        '${client['firstName'] ?? 'Unnamed'} ${client['lastName'] ?? 'Client'}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreenCreative(
                              clientFirstName: client['firstName'] ?? 'Unknown',
                              clientLastName: client['lastName'] ?? 'Unknown',
                              recipientClientId: client['id'],
                              senderCreativeId:
                                  currentCreativeId ?? 'unknownCreativeId',
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
