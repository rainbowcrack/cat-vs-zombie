import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'over_screen.dart';

class RunnerGameScreen extends StatefulWidget {
  final String selectedAvatar;
  final String selectedArm;

  const RunnerGameScreen({
    super.key,
    required this.selectedAvatar,
    required this.selectedArm,
  });

  @override
  State<RunnerGameScreen> createState() => _RunnerGameScreenState();
}

class _RunnerGameScreenState extends State<RunnerGameScreen> {
  int frame = 0;
  int lives = 14;
  int level = 1;

  double worldX = 0.0;
  final double groundY = 292.0;

  Timer? loop;
  final Random rng = Random();

  final List<Zombie> zombies = [];
  final List<Boom> booms = [];

  late double sceneWidth;

  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    loop = Timer.periodic(const Duration(milliseconds: 60), (_) {
      _update();
    });
  }

  @override
  void dispose() {
    loop?.cancel();
    super.dispose();
  }

  void _goToGameOver() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OverScreen(score: level),
      ),
    );
  }

  void _update() {
    if (!mounted || gameOver) return;

    final size = MediaQuery.of(context).size;

    setState(() {
      sceneWidth = size.width * 6;

      worldX -= 3.0;
      if (worldX <= -size.width * 6) {
        worldX = 0.0;
        level++;
      }

      frame = (frame + 1) % 8;

      // spawn zombies
      if (rng.nextDouble() < 0.02 + level * 0.002) {
        final type = rng.nextBool() ? 'gute' : 'lulu';

        zombies.add(Zombie(
          x: size.width + rng.nextDouble() * 200,
          y: groundY,
          speed: 2.0 + level * 0.3,
          hp: level,
          type: type,
        ));
      }

      // update zombies + colisão
      for (final z in zombies) {
        z.x -= z.speed;

        if (z.x < 100 && !z.dead) {
          lives--;
          z.dead = true;
        }
      }

      zombies.removeWhere((z) => z.dead);
      booms.removeWhere((b) => b.tick++ > 15);

      // GAME OVER
      if (lives <= 0) {
        gameOver = true;
        loop?.cancel();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _goToGameOver();
        });
      }
    });
  }

  void _hitZombie(Zombie z) {
    setState(() {
      z.hp--;

      if (z.hp <= 0) {
        z.dead = true;
        booms.add(Boom(z.x, z.y));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    sceneWidth = size.width * 6;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(worldX, 0),
              child: Row(
                children: List.generate(6, (i) {
                  return Image.asset(
                    'assets/images/scenes/${i + 1}.png',
                    width: size.width,
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
          ),

          ...zombies.map((z) {
            return Positioned(
              left: z.x,
              top: z.y,
              child: GestureDetector(
                onTap: () => _hitZombie(z),
                child: Image.asset(
                  'assets/images/zombies/${z.type}/${frame + 1}.png',
                  width: 90,
                ),
              ),
            );
          }),

          ...booms.map((b) {
            final opacity = (1.0 - b.tick / 15).clamp(0.0, 1.0);

            return Positioned(
              left: b.x,
              top: b.y,
              child: Opacity(
                opacity: opacity,
                child: Image.asset(
                  'assets/images/boom/storm.png',
                  width: 70,
                ),
              ),
            );
          }),

          // 👇 CAT PRINCIPAL (JOGADOR)
          _cat(widget.selectedAvatar, size, true),

          // 👇 CAT INIMIGO
          _cat(
            widget.selectedAvatar == 'lulu' ? 'gute' : 'lulu',
            size,
            false,
          ),

          Positioned(
            top: 40,
            left: 20,
            child: Text(
              "❤️ $lives | Level $level | Arma: ${widget.selectedArm}",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 AQUI ESTÁ A MÁGICA DA ANIMAÇÃO
  Widget _cat(String avatar, Size size, bool front) {
    final isPlayer = avatar == widget.selectedAvatar;
    final folder = isPlayer ? 'arm' : 'runner';

    return Positioned(
      left: front ? 140 : 90,
      top: groundY,
      child: Image.asset(
        'assets/images/cat/$avatar/$folder/${frame + 1}.png',
        width: front ? 130 : 110,
      ),
    );
  }
}

// MODELS

class Zombie {
  double x;
  double y;
  double speed;
  int hp;
  bool dead;
  String type;

  Zombie({
    required this.x,
    required this.y,
    required this.speed,
    required this.hp,
    required this.type,
    this.dead = false,
  });
}

class Boom {
  double x;
  double y;
  int tick;

  Boom(this.x, this.y, [this.tick = 0]);
}