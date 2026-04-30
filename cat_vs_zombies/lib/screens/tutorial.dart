import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          "Tutorial em construção...",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}