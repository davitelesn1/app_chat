import 'dart:io';
import 'package:chat_app/core/models/chat_user.dart';
import 'package:chat_app/core/services/auth/auth_firebase_service.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future<ChatUser> signup({
    required String name,
    required String email,
    required String password,
    File image,
  });
  Future<ChatUser> login({required String email, required String password});

  Future<void> logout();

  factory AuthService() => AuthFirebaseService();

}
