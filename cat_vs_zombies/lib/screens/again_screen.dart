import 'package:flutter/material.dart';
import 'select_avatar.dart';

class AgainScreen extends StatelessWidget {
  const AgainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/again.png'),
              fit: BoxFit.cover,
            ),
          ),

          /// BOTÃO
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.05),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectAvatarScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.015,
                  ),
                ),
                child: Text(
                  'Jogar novamente',
                  style: TextStyle(
                    fontSize: size.width * 0.02,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}