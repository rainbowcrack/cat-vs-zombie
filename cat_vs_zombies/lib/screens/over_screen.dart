import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'again_screen.dart';

class OverScreen extends StatefulWidget {
  final int score;

  const OverScreen({
    super.key,
    required this.score,
  });

  @override
  State<OverScreen> createState() => _OverScreenState();
}

class _OverScreenState extends State<OverScreen> {
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
        AssetSource('audio/over.mp3'), // 👈 padrão correto
        volume: 1.0,
      );
    } catch (e) {
      debugPrint("Erro áudio OverScreen (ignorado): $e");
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
              image: AssetImage('assets/images/credit.png'),
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

          /// SCORE + BOTÃO
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Score: ${widget.score}',
                    style: TextStyle(
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: size.width * 0.05,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AgainScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}