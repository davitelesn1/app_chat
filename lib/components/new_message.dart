import 'package:chat_app/core/services/auth/auth_service..dart';
import 'package:chat_app/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final user = AuthService().currentUser;
    final text = _messageController.text.trim();

    if (user == null || text.isEmpty) return;

    await ChatService().save(text, user);
    setState(() {
      _messageController.clear();
      _message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged:
                (msg) => setState(() {
                  _message = msg;
                }),
            decoration: const InputDecoration(labelText: 'Send a message...'),
            onSubmitted: (_) => _sendMessage(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _message.trim().isEmpty ? null : _sendMessage ,
        ),
      ],
    );
  }
}
