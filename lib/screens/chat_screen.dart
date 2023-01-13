import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FlutterChat'),actions: [
        IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: Icon(Icons.logout))
      ],),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/n16P0GnR5ns3F1Xl1Vet/messages')
            .snapshots(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Messages(snapshot.data!.docs),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/n16P0GnR5ns3F1Xl1Vet/messages')
              .add({'text': "this is floating button text"});
        },
        child: const Icon(Icons.add),
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
      itemCount: document.length,
      itemBuilder: ((context, index) => Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(document[index]['text']),
          )),
    );
  }
}
