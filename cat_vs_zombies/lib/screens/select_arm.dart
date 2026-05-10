import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

import 'runner_game_flame.dart';

class SelectArmScreen extends StatefulWidget {
  final String selectedAvatar;

  const SelectArmScreen({
    super.key,
    required this.selectedAvatar,
  });

  @override
  State<SelectArmScreen> createState() => _SelectArmScreenState();
}

class _SelectArmScreenState extends State<SelectArmScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;

  late AnimationController controller;
  late Animation<double> fade;
  late Animation<double> scale;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool soundOn = true;

  final arms = [
    {
      "name": "Green Blaster",
      "image": "assets/images/arms/green.png",
      "description": "Arma equilibrada com disparos rápidos e boa precisão.",
    },
    {
      "name": "Purple Cannon",
      "image": "assets/images/arms/purple.png",
      "description": "Arma poderosa com tiros energéticos e alto impacto.",
    }
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    fade = Tween<double>(begin: 0.5, end: 1).animate(controller);
    scale = Tween<double>(begin: 0.98, end: 1).animate(controller);

    controller.forward();

    _playMusic();
  }

  /// 🎵 música com proteção (NUNCA quebra jogo)
  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      await _audioPlayer.play(
        AssetSource('audio/start.wav'),
        volume: 1.0,
      );
    } catch (e) {
      debugPrint("Audio error ignorado: $e");
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
      debugPrint("Toggle audio error ignorado: $e");
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void playSound() {
    SystemSound.play(SystemSoundType.click);
  }

  void change(int newIndex) {
    setState(() => index = newIndex);
    playSound();
    controller.forward(from: 0);
  }

  void next() => change((index + 1) % arms.length);
  void prev() => change((index - 1 + arms.length) % arms.length);

  void _chooseArm() {
    final selectedArm = arms[index]["name"].toString().toLowerCase();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RunnerGameScreen(
          selectedAvatar: widget.selectedAvatar,
          selectedArm: selectedArm,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arm = arms[index];

    const double cardWidth = 230;
    const double cardHeight = 330;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/arm-choose.png",
              fit: BoxFit.cover,
            ),
          ),

          /// 🔊 BOTÃO SOM
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleSound,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  soundOn ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: fade,
              child: ScaleTransition(
                scale: scale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: prev,
                      icon: const Icon(Icons.arrow_left,
                          size: 50, color: Colors.white),
                    ),

                    Container(
                      width: cardWidth,
                      height: cardHeight,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        children: [
                          Text(
                            arm["name"] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            height: 160,
                            child: Image.asset(
                              arm["image"] as String,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            arm["description"] as String,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const Spacer(),

                          ElevatedButton(
                            onPressed: _chooseArm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                            ),
                            child: const Text(
                              "Escolha",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: next,
                      icon: const Icon(Icons.arrow_right,
                          size: 50, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}