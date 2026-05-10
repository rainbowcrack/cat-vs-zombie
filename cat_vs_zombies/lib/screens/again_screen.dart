import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'select_avatar.dart';

class AgainScreen extends StatefulWidget {
  const AgainScreen({super.key});

  @override
  State<AgainScreen> createState() => _AgainScreenState();
}

class _AgainScreenState extends State<AgainScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool soundOn = true;

  @override
  void initState() {
    super.initState();
    _playMusic();
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      await _audioPlayer.play(
        AssetSource('audio/over.mp3'), // 👈 padronizado
        volume: 1.0,
      );
    } catch (e) {
      debugPrint("Erro áudio AgainScreen (ignorado): $e");
    }
  }

  Future<void> _toggleSound() async {
    setState(() => soundOn = !soundOn);

    try {
      if (soundOn) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.pause();
      }
    } catch (e) {
      debugPrint("Erro toggle áudio (ignorado): $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

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

          /// BOTÃO SOM
          Positioned(
            top: size.height * 0.05,
            right: size.width * 0.03,
            child: GestureDetector(
              onTap: _toggleSound,
              child: Container(
                padding: EdgeInsets.all(size.width * 0.012),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  soundOn ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: size.width * 0.025,
                ),
              ),
            ),
          ),

          /// BOTÃO JOGAR NOVAMENTE
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