import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../audio/audio_manager.dart';
import 'over_screen.dart';

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

class Boss {
  double x;
  double y;
  double speed;
  int hp;
  int frame;
  bool dead;

  Boss({
    required this.x,
    required this.y,
    required this.speed,
    required this.hp,
    this.frame = 0,
    this.dead = false,
  });
}

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
  //
  // AUDIO GLOBAL
  //
  final AudioManager _audio = AudioManager();

  int frame = 0;
  int lives = 14;
  int level = 1;
  int kills = 0;

  double worldX = 0.0;
  final double groundY = 292.0;

  double screenW = 0;

  Timer? loop;
  final Random rng = Random();

  final List<Zombie> zombies = [];
  final List<Boom> booms = [];
  final List<Boss> bosses = [];

  bool gameOver = false;

  int get score => kills * 10 + level * 50;

  bool get isBossLevel => level % 2 == 0;

  @override
  void initState() {
    super.initState();

    _startGameMusic();

    loop = Timer.periodic(
      const Duration(milliseconds: 60),
      (_) => _update(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    screenW = MediaQuery.of(context).size.width;
  }

  //
  // MÚSICA DO GAME
  //
  Future<void> _startGameMusic() async {
    try {
      //
      // PARA QUALQUER MÚSICA ANTERIOR
      //
      await _audio.stopMusic();

      //
      // TOCA GAME
      //
      await _audio.playMusic('audio/game.mp3');
    } catch (e) {
      debugPrint('Erro áudio game: $e');
    }
  }

  //
  // MUTE GLOBAL
  //
  Future<void> _toggleSound() async {
    try {
      await _audio.toggleMute();

      setState(() {});
    } catch (e) {
      debugPrint('Erro mute: $e');
    }
  }

  //
  // SPAWN BOSS
  //
  void _spawnBoss() {
    bosses.add(
      Boss(
        x: screenW + 300,
        y: groundY - 140,
        speed: 1.4,
        hp: level * 10,
      ),
    );
  }

  //
  // LOOP GAME
  //
  void _update() {
    if (!mounted || gameOver) return;

    setState(() {
      worldX -= 3;

      if (worldX <= -screenW * 6) {
        worldX = 0;

        level++;

        if (isBossLevel) {
          _spawnBoss();
        }
      }

      frame = (frame + 1) % 8;

      //
      // SPAWN ZOMBIES
      //
      if (!isBossLevel && rng.nextDouble() < (0.015 + level * 0.015)) {
        zombies.add(
          Zombie(
            x: screenW + rng.nextDouble() * 300,
            y: groundY,
            speed: 2 + level * 0.8,
            hp: level,
            type: rng.nextBool() ? 'gute' : 'lulu',
          ),
        );
      }

      //
      // MOVE ZOMBIES
      //
      for (final z in zombies) {
        z.x -= z.speed;

        if (z.x < 120 && !z.dead) {
          lives--;

          z.dead = true;
        }
      }

      zombies.removeWhere((z) => z.dead);

      //
      // BOOMS
      //
      booms.removeWhere((b) => b.tick++ > 15);

      //
      // MOVE BOSSES
      //
      for (final b in bosses) {
        b.x -= b.speed;

        b.frame = (b.frame + 1) % 8;

        if (b.x < 120 && !b.dead) {
          lives -= 5;

          b.dead = true;
        }
      }

      bosses.removeWhere((b) => b.dead);

      //
      // GAME OVER
      //
      if (lives <= 0) {
        gameOver = true;

        loop?.cancel();

        _audio.stopMusic();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OverScreen(score: score),
          ),
        );
      }
    });
  }

  //
  // HIT ZOMBIE
  //
  Future<void> _hitZombie(Zombie z) async {
    //
    // SOM LASER
    //
    await _audio.playSfx('audio/laser.wav');

    setState(() {
      z.hp--;

      if (z.hp <= 0) {
        z.dead = true;

        kills++;

        booms.add(Boom(z.x, z.y));
      }
    });

    //
    // SOM ZOMBIE MORRENDO
    //
    if (z.hp <= 0) {
      await _audio.playSfx('audio/zombie.wav');
    }
  }

  //
  // HIT BOSS
  //
  Future<void> _hitBoss(Boss b) async {
    //
    // SOM LASER
    //
    await _audio.playSfx('audio/laser.wav');

    setState(() {
      b.hp--;

      if (b.hp <= 0) {
        b.dead = true;

        kills += 10;

        booms.add(Boom(b.x, b.y));
      }
    });

    //
    // SOM MORTE
    //
    if (b.hp <= 0) {
      await _audio.playSfx('audio/zombie.wav');
    }
  }

  @override
  void dispose() {
    loop?.cancel();

    //
    // NÃO DAR DISPOSE NO SINGLETON
    //
    _audio.stopMusic();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerAvatar = widget.selectedAvatar;

    final enemyAvatar =
        playerAvatar == 'lulu' ? 'gute' : 'lulu';

    return Scaffold(
      body: Stack(
        children: [
          //
          // BACKGROUND
          //
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(worldX, 0),
              child: Row(
                children: List.generate(
                  6,
                  (i) {
                    return Image.asset(
                      'assets/images/scenes/${i + 1}.png',
                      width: screenW,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),

          //
          // ZOMBIES
          //
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

          //
          // BOSSES
          //
          ...bosses.map((b) {
            return Positioned(
              left: b.x,
              top: b.y,
              child: GestureDetector(
                onTap: () => _hitBoss(b),
                child: Image.asset(
                  'assets/images/boss/${b.frame + 1}.png',
                  width: 280,
                ),
              ),
            );
          }),

          //
          // EXPLOSÃO
          //
          ...booms.map((b) {
            final opacity =
                (1 - b.tick / 15).clamp(0.0, 1.0);

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

          //
          // PLAYER
          //
          Positioned(
            left: 140,
            top: groundY,
            child: Image.asset(
              'assets/images/cat/$playerAvatar/arm/${frame + 1}.png',
              width: 130,
            ),
          ),

          //
          // ENEMY CAT
          //
          Positioned(
            left: 90,
            top: groundY,
            child: Image.asset(
              'assets/images/cat/$enemyAvatar/runner/${frame + 1}.png',
              width: 110,
            ),
          ),

          //
          // HUD
          //
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "❤️ $lives   |   LV $level   |   SCORE $score",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          //
          // SOUND BUTTON
          //
          Positioned(
            top: 35,
            right: 20,
            child: GestureDetector(
              onTap: _toggleSound,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _audio.isMuted
                      ? Icons.volume_off
                      : Icons.volume_up,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}