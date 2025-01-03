import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // This removes the debug banner
      home: TransactionHistoryPage(),
    );
  }
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  TransactionHistoryPageState createState() => TransactionHistoryPageState();
}

class TransactionHistoryPageState extends State<TransactionHistoryPage> {
  bool isSentSelected = false;
  bool hasTransactions =
      false; // To control whether there are ongoing transactions

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: const Color(0xFF7B3A3F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Implement navigation if needed
          },
        ),
      ),
      body: Column(
        children: [
          // Toggle buttons for Received and Sent
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              selectedColor: Colors.white,
              fillColor: const Color(0xFF7B3A3F),
              isSelected: const <bool>[],
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Received'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Sent'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: hasTransactions
                  ? ListView(
                      // If there are transactions, display them here
                      children: const [
                        ListTile(
                          title: Text('Transaction 1'),
                          subtitle: Text('Details about Transaction 1'),
                        ),
                        ListTile(
                          title: Text('Transaction 2'),
                          subtitle: Text('Details about Transaction 2'),
                        ),
                        // Add more transactions here
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No ongoing transactions',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
