import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'select_avatar.dart';
import '../storage/score_history.dart';

class AgainScreen extends StatefulWidget {
  const AgainScreen({super.key});

  @override
  State<AgainScreen> createState() => _AgainScreenState();
}

class _AgainScreenState extends State<AgainScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool soundOn = true;
  bool loadingScores = true;
  List<ScoreEntry> previousScores = const [];

  @override
  void initState() {
    super.initState();
    _loadScores();
    _playMusic();
  }

  Future<void> _loadScores() async {
    try {
      final scores = await ScoreHistory.getScores();
      if (!mounted) return;

      setState(() {
        previousScores = scores.take(3).toList();
        loadingScores = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar scores (ignorado): $e");
      if (!mounted) return;

      setState(() => loadingScores = false);
    }
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      await _audioPlayer.play(
        AssetSource('audio/over.wav'),
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
    final scoreCardWidth = (size.width * 0.32).clamp(230.0, 340.0).toDouble();

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

          /// SCORES ANTERIORES
          Align(
            alignment: Alignment.center,
            child: Container(
              width: scoreCardWidth,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.018,
                vertical: size.height * 0.025,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Scores anteriores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          (size.width * 0.02).clamp(16.0, 22.0).toDouble(),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.018),
                  if (loadingScores)
                    const SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white70,
                        strokeWidth: 2,
                      ),
                    )
                  else if (previousScores.isEmpty)
                    const Text(
                      'Nenhuma partida salva ainda',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    ...List.generate(previousScores.length, (index) {
                      final entry = previousScores[index];

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == previousScores.length - 1 ? 0 : 8,
                        ),
                        child: _ScoreRow(
                          position: index + 1,
                          score: entry.score,
                        ),
                      );
                    }),
                ],
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

class _ScoreRow extends StatelessWidget {
  final int position;
  final int score;

  const _ScoreRow({
    required this.position,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '#$position',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Partida',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            '$score pts',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
