import 'dart:io';
import 'dart:async';
import 'package:chat_app/core/models/chat_user.dart';
import 'package:chat_app/core/services/auth/auth_service..dart';

class AuthMockService implements AuthService {
  static final _defaultUser = ChatUser(
    id: 'user1',
    name: 'User One',
    email: 'default@example.com',
    imageUrl: 'assets/images/default_user.png',
  );

  static Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });

  ChatUser? get currentUser => _currentUser;

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<ChatUser> signup({
    required String email,
    File? image,
    required String name,
    required String password,
  }) async {
    final newUser = ChatUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
  imageUrl: image?.path ?? 'assets/images/default_user.png',
    );
    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
    return newUser;
  }

  Future<ChatUser> login({required String email, required String password}) async {
    final user = _users[email];
    if (user == null) {
      throw Exception('User not found');
    }
    _updateUser(user);
    return user;
  }

  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
