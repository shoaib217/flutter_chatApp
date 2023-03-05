import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessage> {
  var _messageController = new TextEditingController();
  var _enteredText = "";

  void _sendMessage() async {
    if(_enteredText.trim().isEmpty){
      return;
    }
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredText,
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'userImage': userData['image_url']
    });
    _messageController.clear();
    _enteredText = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8,bottom: 8),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Send a Message...'),
              onChanged: (value) {
                setState(() {
                  _enteredText = value;
                });
              },
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                _sendMessage();
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.green),
            child: IconButton(
                onPressed: _enteredText.trim().isEmpty ? null : _sendMessage,
                icon: const Icon(Icons.send,color: Colors.white,),),
          )
        ],
      ),
    );
  }
}
