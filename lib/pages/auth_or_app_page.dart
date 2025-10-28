import 'package:chat_app/core/models/chat_user.dart';
import 'package:chat_app/core/services/auth/auth_service..dart';
import 'package:chat_app/pages/auth_page.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});


  Future <void> init() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {

        return StreamBuilder<ChatUser?>(
          stream: AuthService().userChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            } else {
              return snapshot.hasData ? const ChatPage() : const AuthPage();
            }
          },
        );
        }
      },
    );
  }
}