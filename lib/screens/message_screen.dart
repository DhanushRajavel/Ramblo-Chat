import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rablo_chat/constants.dart';

class MessageScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverUserName;

  const MessageScreen({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserName,
    required this.receiverUserID,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final messageController = TextEditingController();
  String? editingMessageId;
  late final String currentUserId;
  late final String chatRoomId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    chatRoomId = generateChatId();
  }

  String generateChatId() {
    List<String> ids = [currentUserId, widget.receiverUserID];
    ids.sort();
    return ids.join("_");
  }

  void storeChatData() async {
    if (messageController.text.isEmpty) return;

    final messageText = messageController.text;
    messageController.clear();

    if (editingMessageId != null) {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(editingMessageId)
          .update({'text': messageText});
      editingMessageId = null;
    } else {
      await FirebaseFirestore.instance.collection('messages').add({
        'chatId': chatRoomId,
        'senderId': currentUserId,
        'receiverId': widget.receiverUserID,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          widget.receiverUserName,
          style: kAppBarTitleStyle().copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                      hintStyle: kCommonTextStyle(),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 25,
                  child: IconButton(
                    onPressed: storeChatData,
                    icon: const Icon(Icons.send, size: 30, color: Colors.white),
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
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('chatId', isEqualTo: chatRoomId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final messages = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];
              bool isMe = currentUserId == message['senderId'];
              return GestureDetector(
                onTap: isMe
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return _buildEditOrDeleteOption(
                              message.id,
                              message['text'],
                            );
                          },
                        );
                      }
                    : null,
                child: _buildMessageBubble(
                  isMe ? 'You' : widget.receiverUserEmail,
                  message['text'],
                  isMe,
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text(
              'Start your conversation with ${widget.receiverUserName}',
              style: kCommonTextStyle(),
            ),
          );
        }
      },
    ));
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
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
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
