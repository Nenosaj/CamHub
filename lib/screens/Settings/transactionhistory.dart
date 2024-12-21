import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  final bool isClient; // True if the user is a client, false if creative

  const TransactionHistory({super.key, required this.isClient});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final User? currentUser =
      FirebaseAuth.instance.currentUser; // Get the current user
  List<Map<String, dynamic>> transactions = []; // List to store transactions
  bool isLoading = true; // To handle loading state

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  // Fetch transactions from Firestore based on user role
  Future<void> fetchTransactions() async {
    if (currentUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      String userId = currentUser!.uid;
      QuerySnapshot snapshot;

      if (widget.isClient) {
        // Fetch transactions where the user is the client
        snapshot = await FirebaseFirestore.instance
            .collection('transactions')
            .where('clientId', isEqualTo: userId)
            .get();
      } else {
        // Fetch transactions where the user is the creative
        snapshot = await FirebaseFirestore.instance
            .collection('transactions')
            .where('creativeId', isEqualTo: userId)
            .get();
      }

      List<Map<String, dynamic>> transactionData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        Timestamp? timestamp = data['timestamp'] as Timestamp?;
        String formattedDate = timestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    timestamp.millisecondsSinceEpoch)
                .toLocal()
                .toString()
            : 'N/A';
        return {
          'transactionId': doc.id,
          'bookingId': data['bookingId'] ?? 'N/A',
          'packageId': data['packageId'] ?? 'N/A',
          'clientId': data['clientId'] ?? 'N/A',
          'amount': data['totalAmount'] ?? 0.0,
          'status': data['status'] ?? 'N/A',
          'date': formattedDate,
        };
      }).toList();

      setState(() {
        transactions = transactionData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching transactions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isClient
            ? 'Client Transaction History'
            : 'Creative Transaction History'),
        backgroundColor: const Color(0xFF662C2B),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
              ? const Center(
                  child: Text('No Transactions Found'),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Transaction ID')),
                      DataColumn(label: Text('Booking ID')),
                      if (!widget.isClient)
                        DataColumn(
                            label: Text('Client ID')), // Only for creatives
                      DataColumn(label: Text('Package ID')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Date')),
                    ],
                    rows: transactions.map((transaction) {
                      return DataRow(cells: [
                        DataCell(Text(transaction['transactionId'])),
                        DataCell(Text(transaction['bookingId'])),
                        if (!widget.isClient)
                          DataCell(Text(
                              transaction['clientId'])), // Only for creatives
                        DataCell(Text(transaction['packageId'])),
                        DataCell(Text(
                            '₱${transaction['amount'].toStringAsFixed(2)}')),
                        DataCell(Text(transaction['status'])),
                        DataCell(Text(transaction['date'])),
                      ]);
                    }).toList(),
                  ),
                ),
    );
  }
}
