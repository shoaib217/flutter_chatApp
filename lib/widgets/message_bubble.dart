import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message, this.isMe, this.username, this.imageUrl,
      {super.key});
  final String message;
  final String username;
  final String imageUrl;
  final bool isMe;

  void _openImageDialog(BuildContext ctx, String imgUrl) {
    showDialog(
        context: ctx,
        builder: (context) {
          return Dialog(
              child: Image.network(
            imgUrl,
            fit: BoxFit.cover,
          ));
        });
  }

  Widget _setUserImage(BuildContext ctx, imgUrl) {
    return TextButton(
      onPressed: () => _openImageDialog(ctx, imgUrl),
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe) _setUserImage(context, imageUrl),
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Text(
                username,
                style: TextStyle(
                    color: Colors.grey[800], fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline5!.color,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        if (isMe) _setUserImage(context, imageUrl)
      ],
    );
  }
}
