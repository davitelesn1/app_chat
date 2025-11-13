import 'dart:async';

import 'package:chat_app/core/models/chat_message.dart';
import 'package:chat_app/core/models/chat_user.dart';
import 'package:chat_app/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;

class ChatFirebaseService implements ChatService {
  // Use the same databaseId approach as AuthFirebaseService
  static const String _firestoreDatabaseId = String.fromEnvironment(
    'FIRESTORE_DB_ID',
    defaultValue: 'chat-app-id',
  );

  FirebaseFirestore get _store => FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: _firestoreDatabaseId,
      );

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _store
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((query) => query.docs.map((doc) {
              final data = doc.data();
              final createdRaw = data['createdAt'];
              DateTime createdAt;
              if (createdRaw is Timestamp) {
                createdAt = createdRaw.toDate();
              } else if (createdRaw is String) {
                createdAt = DateTime.tryParse(createdRaw) ?? DateTime.now();
              } else {
                createdAt = DateTime.now();
              }

              return ChatMessage(
                id: doc.id,
                text: data['text'] as String? ?? '',
                createdAt: createdAt,
                userId: data['userId'] as String? ?? '',
                userName: data['userName'] as String? ?? '',
                userImageUrl: data['userImageUrl'] as String? ?? '',
              );
            }).toList());
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final now = Timestamp.now();
    final ref = await _store.collection('chat').add({
      'text': text,
      'createdAt': now,
      'userId': user.id,
      'userName': user.name,
      'userImageUrl': user.imageUrl ?? 'assets/images/default_user.png',
    });

    return ChatMessage(
      id: ref.id,
      text: text,
      createdAt: now.toDate(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl ?? 'assets/images/default_user.png',
    );
  }
}
 