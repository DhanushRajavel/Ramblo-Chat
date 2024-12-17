// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rablo_chat/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final messageController = TextEditingController();
  String? editingMessageId;

  void storeChatData() async {
    if (editingMessageId != null) {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(editingMessageId)
          .update({'text': messageController.text});
      editingMessageId = null;
    } else {
      await FirebaseFirestore.instance.collection('messages').add({
        'email': FirebaseAuth.instance.currentUser!.email.toString(),
        'text': messageController.text,
        'creator': FirebaseAuth.instance.currentUser!.uid.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Rablo Chat',
          style: kAppBarTitleStyle().copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMessageStream(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: 'Type your message here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        hintStyle: kCommonTextStyle()),
                  ),
                ),
                const SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 25,
                  child: IconButton(
                    onPressed: storeChatData,
                    icon: Icon(Icons.send, size: 30, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var message = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.currentUser!.uid == message['creator']
                      ? showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return _buildEditOrDeleteOption(
                              message.id,
                              message['text'],
                            );
                          },
                        )
                      : null;
                },
                child: _buildMessageBubble(
                  message['email'],
                  message['text'],
                  FirebaseAuth.instance.currentUser!.uid == message['creator'],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(String sender, String text, bool isMe) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: kSenderTextStyle()),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(30),
                  ),
            elevation: 5,
            color: isMe ? Colors.blueAccent : Colors.pinkAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: kCommonTextStyle().copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditOrDeleteOption(String messageId, String currentText) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                messageController.text = currentText;
                editingMessageId = messageId;
              });
              Navigator.pop(context);
            },
            child: const Text('Edit'),
          ),
          const Divider(),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('messages')
                  .doc(messageId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
