import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message,this.isMe, {super.key});
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            decoration: BoxDecoration(
                color: isMe ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(12)),
            child: Text(
              message,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline5!.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
