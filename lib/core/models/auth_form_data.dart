import 'dart:io';

enum AuthMode { signup, login }

class AuthFormData {
  String username= '';
  String email= '';
  String password= '';
  File? image;
  AuthMode _mode= AuthMode.login;

  bool get isLogin => _mode == AuthMode.login;
  bool get isSignup => _mode == AuthMode.signup;

void toggleMode() {
    _mode = isLogin ? AuthMode.signup : AuthMode.login;
  }

}