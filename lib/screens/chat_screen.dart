import 'package:chat_app/widgets/message_bubble.dart';
import 'package:chat_app/widgets/new_messages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Messages(snapshot.data!.docs),
            ),
          ),
          NewMessage()
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> document;
  const Messages(this.document, {super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: document.length,
      itemBuilder: ((context, index) => Container(
            padding: const EdgeInsets.all(8.0),
            child: MessageBubble(
              document[index]['text'],
              document[index]['userId'] ==
                  FirebaseAuth.instance.currentUser?.uid,
              document[index]['username'],
              key: ValueKey(document[index].id),
            ),
          )),
    );
  }
}
