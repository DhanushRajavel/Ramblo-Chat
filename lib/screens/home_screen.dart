import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rablo_chat/constants.dart';
import 'package:rablo_chat/screens/message_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("creator",
                isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No users found.',
                style: kCommonTextStyle(),
              ),
            );
          }

          var userDocs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              var user = userDocs[index];
              var name = user['name'] ?? 'Unknown User';
              var email = user['email'] ?? 'No Email';
              var uid = user['creator'] ?? 'No uid';
              return Column(
                children: [
                  _buildUserProfileCard(name, email, uid),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUserProfileCard(
      String username, String userEmail, String userUid) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessageScreen(
                      receiverUserEmail: userEmail,
                      receiverUserID: userUid,
                      receiverUserName: username,
                    )));
      },
      child: Card(
        color: const Color(0xFFF1EEFC),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: kCommonTextStyle(),
                  ),
                  Text(
                    userEmail,
                    style: kSenderTextStyle(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessageScreen(
                              receiverUserEmail: userEmail,
                              receiverUserID: userUid,
                              receiverUserName: username,
                            )));
              },
              icon: const Icon(Icons.arrow_forward_ios_sharp),
            ),
          ],
        ),
      ),
    );
  }
}
