import 'package:chat_app/components/auth_form.dart';
import 'package:chat_app/core/models/auth_form_data.dart';
import 'package:chat_app/core/services/auth/auth_service..dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;


  Future<void> _handleSubmit(AuthFormData formData) async {
    setState(() { _isLoading = true; });
    try {
      if (formData.isLogin) {
        await AuthService().login(
          email: formData.email,
          password: formData.password,
        );
      } else {
        await AuthService().signup(
          name: formData.username,
          email: formData.email,
          password: formData.password,
          image: formData.image!,
        );
      }
    } on FirebaseAuthException catch (e) {
      _showError(_mapFirebaseError(e));
    } catch (_) {
      _showError('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
    // Handle form submission
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
        return 'E-mail ou senha inválidos.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Usuário desativado. Contate o suporte.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Verifique as configurações do projeto.';
      default:
        return e.message ?? 'Falha na autenticação.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(
                onSubmit: (formData) {
                  _handleSubmit(formData);
                },
              ),
            ),
          ),
          if (_isLoading) Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

  