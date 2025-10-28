import 'dart:async';

import 'package:chat_app/core/models/chat_message.dart';
import 'package:chat_app/core/models/chat_user.dart';
import 'package:chat_app/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
  //   ChatMessage(
  //     id: '1',
  //     text: 'Good Morning',
  //     createdAt: DateTime.now(),
  //     userId: 'user1',
  //     userName: 'User One',
  //     userImageUrl: 'assets/images/default_user.png',
  //   ),
  //   ChatMessage(
  //     id: '2',
  //     text: 'Hello! How are you?',
  //     createdAt: DateTime.now(),
  //     userId: 'user2',
  //     userName: 'User Two',
  //     userImageUrl: 'assets/images/default_user.png',
  //   ),
  //   ChatMessage(
  //     id: '3',
  //     text: 'I am fine, thank you!',
  //     createdAt: DateTime.now(),
  //     userId: 'user1',
  //     userName: 'User One',
  //     userImageUrl: 'assets/images/default_user.png',
  //   ),
  ];

  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    controller.add(_msgs);
  });

  Stream<List<ChatMessage>> messagesStream() {
    return _msgStream;
  }

  Future<ChatMessage> save(String text, ChatUser user) async {
    final _newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl!,
    );
    _msgs.add(_newMessage);
    _controller?.add(_msgs.reversed.toList());
    return _newMessage;
  }
}
