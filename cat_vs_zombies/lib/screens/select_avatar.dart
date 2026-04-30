import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// IMPORT DA SUA TELA DO JOGO
import 'runner_game_flame.dart';

class SelectAvatarScreen extends StatefulWidget {
  const SelectAvatarScreen({super.key});

  @override
  State<SelectAvatarScreen> createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends State<SelectAvatarScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;

  late AnimationController controller;
  late Animation<double> fade;
  late Animation<double> scale;

  final avatars = [
    {
      "name": "Gute",
      "image": "../assets/images/cat/gute/gute-3d.png",
      "energy": 0.6,
      "empatia": 0.9,
      "intro": 0.6,
      "coragem": 0.5,
      "skills": [
        "Raciocínio rápido",
        "Estrutura de dados",
        "Comunicativo",
        "Gosta de burgers hot pockets"
      ],
    },
    {
      "name": "Lulu",
      "image": "../assets/images/cat/lulu/lulu-3d.png",
      "energy": 0.7,
      "empatia": 0.5,
      "intro": 0.9,
      "coragem": 0.6,
      "skills": [
        "Analítica",
        "Cálculo",
        "Tímida",
        "Gosta de yakissoba e dias chuvosos"
      ],
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
  }

  void playSound() {
    SystemSound.play(SystemSoundType.click);
  }

  void change(int newIndex) {
    setState(() => index = newIndex);
    playSound();
    controller.forward(from: 0);
  }

  void next() => change((index + 1) % avatars.length);
  void prev() => change((index - 1 + avatars.length) % avatars.length);

  void _chooseAvatar() {
    final selected = avatars[index]["name"].toString().toLowerCase();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RunnerGameScreen(
          selectedAvatar: selected,
        ),
      ),
    );
  }

  Widget bar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.white12,
            color: color,
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget hearts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        7,
        (i) => const Icon(Icons.favorite,
            color: Colors.redAccent, size: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatar = avatars[index];

    const double cardWidth = 230;
    const double cardHeight = 330;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "../assets/images/avatar.png",
              fit: BoxFit.cover,
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
                            avatar["name"] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          SizedBox(
                            height: 110,
                            child: Image.asset(
                              avatar["image"] as String,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 6),

                          hearts(),

                          const SizedBox(height: 6),

                          bar("Energia", avatar["energy"] as double,
                              Colors.yellow),
                          const SizedBox(height: 3),
                          bar("Empatia", avatar["empatia"] as double,
                              Colors.pink),
                          const SizedBox(height: 3),
                          bar("Introversão", avatar["intro"] as double,
                              Colors.blue),
                          const SizedBox(height: 3),
                          bar("Coragem", avatar["coragem"] as double,
                              Colors.green),

                          const SizedBox(height: 6),

                          Text(
                            (avatar["skills"] as List<String>).join(", "),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const Spacer(),

                          /// ✅ BOTÃO FUNCIONAL
                          ElevatedButton(
                            onPressed: _chooseAvatar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
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