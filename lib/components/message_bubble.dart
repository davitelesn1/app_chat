import 'dart:io';

import 'package:chat_app/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  static const _defaultImageUrl = 'assets/images/default_user.png';
  final ChatMessage message;
  final bool belongsToCurrentUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.belongsToCurrentUser,
  });

  Widget _showUserImage(String imageUrl) {
    ImageProvider? provider;
    final uri = Uri.parse(imageUrl);
    if (uri.path.contains(_defaultImageUrl)) {
      provider = AssetImage(_defaultImageUrl);
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      backgroundColor: Colors.pink,
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              belongsToCurrentUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    belongsToCurrentUser
                        ? Colors.grey[300]
                        : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft:
                      belongsToCurrentUser
                          ? const Radius.circular(12)
                          : const Radius.circular(0),
                  bottomRight:
                      belongsToCurrentUser
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
                ),
              ),
              width: 180,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment: belongsToCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: belongsToCurrentUser ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: belongsToCurrentUser ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -0,
          left: belongsToCurrentUser ? 210 : null,
          right: belongsToCurrentUser ? null : 210,
          child: _showUserImage(message.userImageUrl),
        ),
      ],
    );
  }
}
