import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  // Fetch user data from Firestore
  Stream<QuerySnapshot> fetchUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text(
          "Users List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            const Text(
              "Registered Users",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10.0),

            // Scrollable Table
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error fetching user data"));
                  }

                  final users = snapshot.data?.docs;

                  if (users == null || users.isEmpty) {
                    return const Center(
                        child: Text("No registered users found."));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          const Color(0xFFF4F4F4),
                        ),
                        columnSpacing: 40.0,
                        headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        dataTextStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.black87),
                        columns: const [
                          DataColumn(
                            label: Text('No.'),
                          ),
                          DataColumn(
                            label: Text('User Email'),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          users.length,
                          (index) {
                            final userData =
                                users[index].data() as Map<String, dynamic>;
                            final userEmail = userData['email'] ?? 'N/A';
                       

                            return DataRow(cells: [
                              DataCell(
                                Text('${index + 1}'),
                              ),
                              DataCell(
                                Text(userEmail),
                              ),
                            ]);
                          },
                        ),
                      ),
                    ),
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
