import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats/n16P0GnR5ns3F1Xl1Vet/messages')
                    .snapshots(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Messages(snapshot.data!.docs));
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        FirebaseFirestore.instance.collection('chats/n16P0GnR5ns3F1Xl1Vet/messages').add({
          'text':"this is floating button text"
        });
      },child: const Icon(Icons.add),),
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
