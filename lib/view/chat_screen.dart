import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String? photoURL;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.photoURL,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final _currentUser = FirebaseAuth.instance.currentUser!;

  // Theme Colors from the new UI
  static const Color darkBg = Color(0xFF0E0F1F);
  static const Color appBarBg = Color(0xFF161B22);
  static const Color cardColor = Color(0xFF1E233A);
  static const Color accentGreen = Color(0xFF00D084);

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    
    // Create the message payload, now including senderName
    final message = {
      'text': messageText,
      'senderId': _currentUser.uid,
      'senderName': _currentUser.displayName ?? 'User', // Added senderName
      'receiverId': widget.userId,
      'timestamp': Timestamp.now(),
    };

    List<String> ids = [_currentUser.uid, widget.userId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Send the message
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message);

    // Clear the controller only after the message is sent
    _messageController.clear();
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    bool isMe = data['senderId'] == _currentUser.uid;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? accentGreen.withOpacity(0.9) : cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          data['text'],
          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> ids = [_currentUser.uid, widget.userId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.photoURL != null && widget.photoURL!.isNotEmpty
                  ? NetworkImage(widget.photoURL!)
                  : null,
              child: widget.photoURL == null || widget.photoURL!.isEmpty
                  ? Text(widget.userName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    "Online",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('Say hi to ${widget.userName}!', style: const TextStyle(color: Colors.white70)),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => _buildMessageItem(snapshot.data!.docs[index]),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: appBarBg, // Use the same color as AppBar for a seamless look
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: darkBg,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey), onPressed: () {}),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.attach_file, color: Colors.grey), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.camera_alt, color: Colors.grey), onPressed: () {}),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              style: IconButton.styleFrom(backgroundColor: accentGreen, padding: const EdgeInsets.all(12)),
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
