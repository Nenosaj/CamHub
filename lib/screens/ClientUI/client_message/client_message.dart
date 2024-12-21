import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderClientId;
  final String recipientCreativeId;
  final String message;
  final DateTime createdAt;

  Message({
    required this.senderClientId,
    required this.recipientCreativeId,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderClientId': senderClientId,
      'recipientCreativeId': recipientCreativeId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      senderClientId: data['senderClientId'] ?? '',
      recipientCreativeId: data['recipientCreativeId'] ?? '',
      message: data['message'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String photographerName;
  final String senderClientId;
  final String recipientCreativeId;

  const ChatScreen({
    super.key,
    required this.photographerName,
    required this.senderClientId,
    required this.recipientCreativeId,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];
  bool _isFetching = false;

  Future<void> _fetchMessages() async {
    setState(() {
      _isFetching = true;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .get();

      setState(() {
        _messages = querySnapshot.docs
            .map((doc) => Message.fromMap(doc.data()))
            .toList();
      });
    } catch (e) {
      print('Error fetching messages: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch messages: $e')),
      );
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Widget _buildMessage(Message message, bool isSender) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color:
                  isSender ? const Color(0xFF662C2B) : const Color(0xFFB3E5FC),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chat with ${widget.photographerName}',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: _isFetching
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.refresh, color: Colors.white),
              onPressed: _fetchMessages,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('No messages yet.'))
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isSender =
                          message.senderClientId == widget.senderClientId;
                      return _buildMessage(message, isSender);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  color: const Color(0xFF662C2B),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      final newMessage = Message(
        senderClientId: widget.senderClientId,
        recipientCreativeId: widget.recipientCreativeId,
        message: messageText,
        createdAt: DateTime.now(),
      );

      FirebaseFirestore.instance.collection('messages').add(newMessage.toMap());

      _messageController.clear();
      _fetchMessages();
    }
  }
}
