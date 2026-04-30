import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class RunnerGameScreen extends StatefulWidget {
  final String selectedAvatar;
  const RunnerGameScreen({super.key, required this.selectedAvatar});

  @override
  State<RunnerGameScreen> createState() => _RunnerGameScreenState();
}

class _RunnerGameScreenState extends State<RunnerGameScreen> {
  // ─────────────────────────
  // STATE
  // ─────────────────────────
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

  // ─────────────────────────
  // GAME LOOP
  // ─────────────────────────
  void _update() {
    if (!mounted) return;

    setState(() {
      final size = MediaQuery.of(context).size;

      sceneWidth = size.width * 6;

      // SCROLL INFINITO FLUIDO (DINO STYLE)
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

      // update zombies
      for (final z in zombies) {
        z.x -= z.speed;

        if (z.x < 100 && !z.dead) {
          lives--;
          z.dead = true;
        }
      }

      zombies.removeWhere((z) => z.dead);

      booms.removeWhere((b) => b.tick++ > 15);
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

  // ─────────────────────────
  // UI
  // ─────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    sceneWidth = size.width * 6;

    return Scaffold(
      body: Stack(
        children: [
          // ─────────────────────────
          // SCENES (CORRETO + FLUIDO)
          // ─────────────────────────
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

          // ─────────────────────────
          // ZOMBIES (2 TIPOS + ANIMAÇÃO 1-8)
          // ─────────────────────────
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

          // ─────────────────────────
          // BOOM
          // ─────────────────────────
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

          // ─────────────────────────
          // CAT FRONT
          // ─────────────────────────
          _cat(widget.selectedAvatar, size, true),

          // ─────────────────────────
          // CAT BACK
          // ─────────────────────────
          _cat(
            widget.selectedAvatar == 'lulu' ? 'gute' : 'lulu',
            size,
            false,
          ),

          // ─────────────────────────
          // HUD
          // ─────────────────────────
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              "❤️ $lives | Level $level",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────
  // CAT
  // ─────────────────────────
  Widget _cat(String avatar, Size size, bool front) {
    return Positioned(
      left: front ? 140 : 90,
      top: groundY,
      child: Image.asset(
        'assets/images/cat/$avatar/runner/${frame + 1}.png',
        width: front ? 130 : 110,
      ),
    );
  }
}

// ─────────────────────────────
// MODELS
// ─────────────────────────────
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