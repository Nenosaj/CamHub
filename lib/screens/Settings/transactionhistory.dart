import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

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
      // Determine the user's role (e.g., client or creative)
      String userId = currentUser!.uid;

      // Fetch transactions where the user is either the client or creative
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('clientId', isEqualTo: userId)
          .get();

      // Fetch creative transactions
      QuerySnapshot creativeSnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('creativeId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> transactionData = [];

      // Process client transactions
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        transactionData.add({
          'transactionId': doc.id,
          'bookingId': data['bookingId'] ?? 'N/A',
          'packageId': data['packageId'] ?? 'N/A',
          'clientId': data['clientId'] ?? 'N/A',
          'amount': data['totalAmount'] ?? 0.0,
          'status': data['status'] ?? 'N/A',
          'date': data['date'] ?? 'N/A',
        });
      }

      // Process creative transactions
      for (var doc in creativeSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        transactionData.add({
          'transactionId': doc.id,
          'bookingId': data['bookingId'] ?? 'N/A',
          'packageId': data['packageId'] ?? 'N/A',
          'creativeId': data['creativeId'] ?? 'N/A',
          'amount': data['totalAmount'] ?? 0.0,
          'status': data['status'] ?? 'N/A',
          'date': data['date'] ?? 'N/A',
        });
      }

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
        title: const Text('Transaction History'),
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
                    columns: const [
                      DataColumn(label: Text('Transaction ID')),
                      DataColumn(label: Text('Booking ID')),
                      DataColumn(label: Text('Client ID')),
                      DataColumn(label: Text('Package ID')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Date')),
                    ],
                    rows: transactions.map((transaction) {
                      return DataRow(cells: [
                        DataCell(Text(transaction['transactionId'])),
                        DataCell(Text(transaction['bookingId'])),
                        DataCell(Text(transaction['clientId'])),
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
