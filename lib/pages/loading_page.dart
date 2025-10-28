import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            CircularProgressIndicator(backgroundColor: Colors.white,),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}