import 'dart:io';

import 'package:chat_app/components/user_image_picker.dart';
import 'package:chat_app/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_formData.isSignup && _formData.image == null) {
     return _showErrorSnackBar('Please pick an image.');
    }

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_formData.isSignup) UserImagePicker(onImagePick: _handleImagePick,),
              if (_formData.isSignup)
                TextFormField(
                  key: ValueKey('username'),
                  initialValue: _formData.username,
                  onChanged: (username) => _formData.username = username,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (username) {
                    final value = username ?? '';
                    if (value.trim().length < 4) {
                      return 'Username must be at least 4 characters long.';
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _formData.email,
                onChanged: (email) => _formData.email = email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (email) {
                  final value = email ?? '';
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (password) => _formData.password = password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (password) {
                  final value = password ?? '';
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_formData.isLogin ? 'Login' : 'Signup'),
              ),
              TextButton(
                child: Text(
                  _formData.isLogin
                      ? 'Create new account'
                      : 'Already have an account?',
                ),
                onPressed: () {
                  setState(() {
                    _formData.toggleMode();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
