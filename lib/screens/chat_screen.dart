import 'package:chat_app/widgets/message_bubble.dart';
import 'package:chat_app/widgets/new_messages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(this.userId, {super.key});
  var userId;

  Future<String> getUserName(String userId) async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    var uname = await user.get('username');
    print('object-- $uname');
    return uname.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserName(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data ?? "FlutterChat"),
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
                const NewMessage()
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class Messages extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> document;
  const Messages(this.document, {super.key});
  void _openDeleteConfirmationDialog(BuildContext ctx, String docId) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'FlutterChat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Are You Sure You Want To Delete The Message?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text(
                  'No',
                ),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('chat')
                      .doc(docId)
                      .delete();
                  Navigator.of(ctx).pop(true);
                },
                child: const Text(
                  'Yes',
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: document.length,
      itemBuilder: ((context, index) => Container(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onLongPress: () {
                _openDeleteConfirmationDialog(context, document[index].id);
              },
              child: MessageBubble(
                document[index]['text'],
                document[index]['userId'] ==
                    FirebaseAuth.instance.currentUser?.uid,
                document[index]['username'],
                document[index]['userImage'],
                key: ValueKey(document[index].id),
              ),
            ),
          )),
    );
  }
}
