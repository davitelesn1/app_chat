import 'dart:io';
import 'dart:async';
import 'package:chat_app/core/models/chat_user.dart';
import 'package:chat_app/core/services/auth/auth_service..dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;

class AuthFirebaseService implements AuthService {
  // If your Firestore database is not the default one, set its ID here.
  // Typically this should be '(default)'. If you created a custom database id,
  // e.g. 'chatdb', change the value below to that id and rebuild the app.
  // You can override this at build time with:
  // flutter run --dart-define=FIRESTORE_DB_ID="(default)" (or your custom id)
  static const String _firestoreDatabaseId = String.fromEnvironment(
    'FIRESTORE_DB_ID',
    defaultValue: 'chat-app-id',
  );
  
  static ChatUser? _currentUser;

  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<ChatUser> signup({
    required String name,
    required String email,
    required String password,
    File? image,
  }) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      throw Exception('Falha ao criar usuário.');
    }

    // 1. Upload da foto do usuário
    final imageName = '${credential.user!.uid}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);

    // 2. atualizar os atributos do usuário
    await credential.user?.updateDisplayName(name);
  await credential.user?.updatePhotoURL(imageUrl);

    // 3. salvar usuário no banco de dados (opcional)
    final chatUser = _toChatUser(credential.user!, imageUrl);
    await _saveChatUser(chatUser);
    _currentUser = chatUser;
    return chatUser;
  }

  @override
  Future<ChatUser> login({
    required String email,
    required String password,
  }) async {
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (cred.user == null) {
      throw Exception('Falha no login.');
    }

    final chatUser = _toChatUser(cred.user!);
    _currentUser = chatUser;
    return chatUser;
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    // Log which database and project we're targeting to aid diagnosis
    print('[AuthFirebaseService] Firestore project: '
        '${Firebase.app().options.projectId} | databaseId: $_firestoreDatabaseId');

    final store = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: _firestoreDatabaseId,
    );
    final docRef = store.collection('users').doc(user.id);

    try {
      await docRef.set({
        'name': user.name,
        'email': user.email,
        'imageUrl': user.imageUrl,
      });
    } on FirebaseException catch (e) {
      print('[AuthFirebaseService] Firestore write error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  static ChatUser _toChatUser(User user, [String? imageUrl]) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
