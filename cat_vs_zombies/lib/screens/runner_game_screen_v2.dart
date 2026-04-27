// lib/screens/runner_game_screen_v2.dart
// Runner Game - Versão Melhorada: Lulu & Gute vs Zombies
// Implementação completa com Flutter puro
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AVATAR SELECTION SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class RunnerSelectScreen extends StatefulWidget {
  const RunnerSelectScreen({super.key});
  @override
  State<RunnerSelectScreen> createState() => _RunnerSelectScreenState();
}

class _RunnerSelectScreenState extends State<RunnerSelectScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgAnim;
  late AnimationController _luluAnim;
  late AnimationController _guteAnim;

  @override
  void initState() {
    super.initState();
    _bgAnim = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat();
    _luluAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _guteAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgAnim.dispose();
    _luluAnim.dispose();
    _guteAnim.dispose();
    super.dispose();
  }

  void _startGame(String avatar) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RunnerGameScreen(selectedAvatar: avatar)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnim,
        builder: (_, __) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFF1a1a2e),
                Color(0xFF16213e),
                Color(0xFF0f3460),
                Color(0xFF533483),
              ],
              transform: GradientRotation(_bgAnim.value * 2 * pi),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  '🐱 CAT VS ZOMBIES 🧟',
                  style: GoogleFonts.bangers(
                    fontSize: 56,
                    color: const Color(0xFFFFD700),
                    letterSpacing: 6,
                    shadows: [
                      Shadow(color: const Color(0xFFFF6B9D).withOpacity(.8), blurRadius: 20),
                    ],
                  ),
                ),
                Text(
                  'Lulu & Gute vs Zombies!',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: const Color(0xFFBBBBFF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Escolha seu avatar:',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _AvatarCard(
                      name: 'LULU',
                      role: 'Protege o Gute',
                      frameCount: 8,
                      framePrefix: 'assets/images/cat/lulu/runner/',
                      color: const Color(0xFFFF6B9D),
                      anim: _luluAnim,
                      onTap: () => _startGame('lulu'),
                    ),
                    _AvatarCard(
                      name: 'GUTE',
                      role: 'Protege a Lulu',
                      frameCount: 8,
                      framePrefix: 'assets/images/cat/gute/runner/',
                      color: const Color(0xFF00E5FF),
                      anim: _guteAnim,
                      onTap: () => _startGame('gute'),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(.15)),
                  ),
                  child: Column(
                    children: [
                      _infoRow('🧟', 'Toque nos zombies para matá-los'),
                      _infoRow('⚡', 'Cada nível exige mais cliques'),
                      _infoRow('❤️', '5 vidas cada - proteja seu par!'),
                      _infoRow('💨', 'Zombies ficam mais rápidos'),
                      _infoRow('🎯', 'Sobreviva a 10 níveis!'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String emoji, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.nunito(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class _AvatarCard extends StatefulWidget {
  final String name, role, framePrefix;
  final int frameCount;
  final Color color;
  final AnimationController anim;
  final VoidCallback onTap;

  const _AvatarCard({
    required this.name,
    required this.role,
    required this.framePrefix,
    required this.frameCount,
    required this.color,
    required this.anim,
    required this.onTap,
  });

  @override
  State<_AvatarCard> createState() => _AvatarCardState();
}

class _AvatarCardState extends State<_AvatarCard> {
  int _frame = 0;
  Timer? _frameTimer;

  @override
  void initState() {
    super.initState();
    _frameTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (mounted) setState(() => _frame = (_frame + 1) % widget.frameCount);
    });
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: widget.anim,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, -8 * widget.anim.value),
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: widget.color, width: 2),
              boxShadow: [
                BoxShadow(color: widget.color.withOpacity(.4), blurRadius: 20, spreadRadius: 2),
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  '${widget.framePrefix}${_frame + 1}.png',
                  height: 90,
                  errorBuilder: (_, __, ___) => Text(
                    widget.name == 'LULU' ? '🐱' : '🐈',
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.name,
                  style: GoogleFonts.bangers(
                    fontSize: 28,
                    color: widget.color,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  widget.role,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'JOGAR',
                    style: GoogleFonts.bangers(
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum GamePhase { playing, paused, gameOver }

class Zombie {
  final String id;
  final int type; // 1 or 2
  double x; // 0.0 – 1.0 of screen width
  double y; // fixed lane
  int hitsLeft;
  int hitsReceived = 0;
  bool dying;
  double dyingTimer;
  final bool targetingLulu;

  Zombie({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.hitsLeft,
    required this.targetingLulu,
    this.dying = false,
    this.dyingTimer = 0,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN GAME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class RunnerGameScreen extends StatefulWidget {
  final String selectedAvatar;
  const RunnerGameScreen({super.key, required this.selectedAvatar});
  @override
  State<RunnerGameScreen> createState() => _RunnerGameScreenState();
}

class _RunnerGameScreenState extends State<RunnerGameScreen>
    with TickerProviderStateMixin {
  GamePhase _phase = GamePhase.playing;
  int _level = 1;
  int _luluLives = 5;
  int _guteLives = 5;
  double _levelTimer = 0;
  static const double _levelDuration = 30.0;
  int _score = 0;

  // Background
  double _bgOffset = 0;
  static const int _sceneCount = 3;
  int _currentScene = 0;

  // Animation
  int _runnerFrame = 0;
  Timer? _frameTimer;
  static const int _frameCount = 8;

  // Zombies
  final List<Zombie> _zombies = [];
  int _zombieCounter = 0;
  final Random _rng = Random();

  // Flash effects
  bool _luluFlash = false;
  bool _guteFlash = false;

  // Boom effects
  final List<_Boom> _booms = [];

  // Game loop
  Timer? _gameTimer;

  // Level banner
  bool _showLevelBanner = false;

  // Audio
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startGame();
  }

  void _startGame() {
    _frameTimer = Timer.periodic(const Duration(milliseconds: 110), (_) {
      if (_phase == GamePhase.playing && mounted) {
        setState(() => _runnerFrame = (_runnerFrame + 1) % _frameCount);
      }
    });

    _gameTimer = Timer.periodic(const Duration(milliseconds: 50), _tick);
  }

  void _tick(Timer _) {
    if (_phase != GamePhase.playing || !mounted) return;
    setState(() {
      // Scroll background
      _bgOffset += 2.5 + _level * 0.3;

      // Level timer
      _levelTimer += 0.05;
      if (_levelTimer >= _levelDuration) {
        _levelTimer = 0;
        _levelUp();
        return;
      }

      // Spawn zombies
      double spawnChance = 0.02 + _level * 0.008;
      if (_rng.nextDouble() < spawnChance && _zombies.length < 4 + _level) {
        _spawnZombie();
      }

      // Move zombies
      double speed = (0.002 + _level * 0.0015);
      List<String> toRemove = [];

      for (final z in _zombies) {
        if (z.dying) {
          z.dyingTimer += 0.05;
          if (z.dyingTimer >= 0.8) toRemove.add(z.id);
        } else {
          z.x -= speed;
          if (z.x < -0.15) {
            toRemove.add(z.id);
            _dealDamage(z.targetingLulu);
          }
        }
      }
      _zombies.removeWhere((z) => toRemove.contains(z.id));

      // Remove expired booms
      _booms.removeWhere((b) {
        b.timer += 0.05;
        return b.timer > 1.0;
      });
    });
  }

  void _spawnZombie() {
    int type = _rng.nextBool() ? 1 : 2;
    bool targetLulu = _rng.nextBool();
    double y = targetLulu ? 0.38 : 0.65;

    _zombieCounter++;
    _zombies.add(Zombie(
      id: 'z$_zombieCounter',
      type: type,
      x: 1.05 + _rng.nextDouble() * 0.2,
      y: y,
      hitsLeft: _level,
      targetingLulu: targetLulu,
    ));
  }

  void _dealDamage(bool toLulu) {
    if (toLulu) {
      _luluLives--;
      _luluFlash = true;
      _playSound('hit');
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _luluFlash = false);
      });
    } else {
      _guteLives--;
      _guteFlash = true;
      _playSound('hit');
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _guteFlash = false);
      });
    }

    if (_luluLives <= 0 || _guteLives <= 0) {
      _triggerGameOver();
    }
  }

  void _onZombieTap(Zombie z) {
    if (z.dying) return;

    setState(() {
      z.hitsReceived++;
      z.hitsLeft--;

      if (z.hitsLeft <= 0) {
        z.dying = true;
        z.dyingTimer = 0;
        _score += _level * 10;
        _booms.add(_Boom(x: z.x, y: z.y));
        _playSound('boom');
      } else {
        _playSound('hit');
      }
    });
  }

  void _levelUp() {
    if (_level < 10) {
      _level++;
      _currentScene = (_currentScene + 1) % _sceneCount;
    }

    _showLevelBanner = true;
    _playSound('levelup');

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showLevelBanner = false);
    });
  }

  void _triggerGameOver() {
    _phase = GamePhase.gameOver;
    _gameTimer?.cancel();
    _frameTimer?.cancel();
    _playSound('gameover');
  }

  void _restartGame() {
    setState(() {
      _phase = GamePhase.playing;
      _level = 1;
      _luluLives = 5;
      _guteLives = 5;
      _levelTimer = 0;
      _score = 0;
      _zombies.clear();
      _booms.clear();
      _currentScene = 0;
      _bgOffset = 0;
    });
    _startGame();
  }

  void _playSound(String soundType) {
    // Implement sound effects using audioplayers
    // Example: _audioPlayer.play(AssetSource('audio/$soundType.mp3'));
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _frameTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _GameBackground(
            bgOffset: _bgOffset,
            sceneIndex: _currentScene,
          ),
          // ZOMBIES
          ..._zombies.map((z) => _ZombieWidget(
            zombie: z,
            screenSize: size,
            level: _level,
            onTap: () => _onZombieTap(z),
          )),
          // BOOM EFFECTS
          ..._booms.map((b) => _BoomWidget(boom: b, screenSize: size)),
          // GROUND
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.18,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF2d4a1e).withOpacity(0.6),
                    const Color(0xFF1a2e10),
                  ],
                ),
              ),
            ),
          ),
          // AVATARS - LULU (top)
          Positioned(
            left: size.width * 0.04,
            top: size.height * 0.28,
            child: _AnimatedAvatar(
              name: 'lulu',
              frame: _runnerFrame,
              isPlayer: widget.selectedAvatar == 'lulu',
              flashRed: _luluFlash,
              size: size.width * 0.18,
            ),
          ),
          // AVATARS - GUTE (bottom)
          Positioned(
            left: size.width * 0.04,
            top: size.height * 0.58,
            child: _AnimatedAvatar(
              name: 'gute',
              frame: _runnerFrame,
              isPlayer: widget.selectedAvatar == 'gute',
              flashRed: _guteFlash,
              size: size.width * 0.18,
            ),
          ),
          // DAMAGE FLASH - LULU
          if (_luluFlash)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.5,
                color: Colors.red.withOpacity(0.3),
              ),
            ),
          // DAMAGE FLASH - GUTE
          if (_guteFlash)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.5,
                color: Colors.red.withOpacity(0.3),
              ),
            ),
          // HUD
          SafeArea(child: _HUD(
            level: _level,
            luluLives: _luluLives,
            guteLives: _guteLives,
            levelTimer: _levelTimer,
            levelDuration: _levelDuration,
            score: _score,
            selectedAvatar: widget.selectedAvatar,
            onBack: () => Navigator.pop(context),
          )),
          // DIVIDER LINE
          Positioned(
            top: size.height * 0.518,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          // LEVEL BANNER
          if (_showLevelBanner)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFFFD700), width: 2),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFFD700).withOpacity(.5), blurRadius: 30),
                  ],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    'NÍVEL $_level',
                    style: GoogleFonts.bangers(
                      fontSize: 48,
                      color: const Color(0xFFFFD700),
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Precisa de $_level cliques por zombie!',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ]),
              ),
            ),
          // GAME OVER OVERLAY
          if (_phase == GamePhase.gameOver)
            _GameOverOverlay(
              score: _score,
              level: _level,
              onRestart: _restartGame,
              onHome: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _GameBackground extends StatelessWidget {
  final double bgOffset;
  final int sceneIndex;

  const _GameBackground({required this.bgOffset, required this.sceneIndex});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scenes = ['assets/images/scenes/1.png', 'assets/images/scenes/1.png', 'assets/images/scenes/1.png'];
    final fallbackColors = [
      [const Color(0xFF1a1a2e), const Color(0xFF0f3460)],
      [const Color(0xFF1a2e1a), const Color(0xFF0f4020)],
      [const Color(0xFF2e1a2e), const Color(0xFF400f3f)],
    ];

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: fallbackColors[sceneIndex],
            ),
          ),
        ),
        for (int i = 0; i < 2; i++)
          Positioned(
            left: (i * size.width) - (bgOffset % size.width),
            top: 0,
            child: Image.asset(
              scenes[sceneIndex],
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        Container(
          color: Colors.black.withOpacity(0.35),
        ),
      ],
    );
  }
}

class _AnimatedAvatar extends StatelessWidget {
  final String name;
  final int frame;
  final bool isPlayer;
  final bool flashRed;
  final double size;

  const _AnimatedAvatar({
    required this.name,
    required this.frame,
    required this.isPlayer,
    required this.flashRed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: isPlayer
                ? [BoxShadow(color: const Color(0xFFFFD700).withOpacity(.6), blurRadius: 12, spreadRadius: 2)]
                : [BoxShadow(color: const Color(0xFF00E5FF).withOpacity(.4), blurRadius: 8)],
          ),
          child: ColorFiltered(
            colorFilter: flashRed
                ? const ColorFilter.mode(Colors.red, BlendMode.srcATop)
                : const ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
            child: Image.asset(
              'assets/images/cat/$name/runner/${frame + 1}.png',
              width: size,
              height: size,
              errorBuilder: (_, __, ___) => Text(
                name == 'lulu' ? '🐱' : '🐈',
                style: TextStyle(fontSize: size * 0.7),
              ),
            ),
          ),
        ),
        if (isPlayer)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withOpacity(.5), blurRadius: 8)],
            ),
            child: Text(
              '★ YOU',
              style: GoogleFonts.bangers(
                fontSize: size * 0.15,
                color: Colors.black87,
                letterSpacing: 1,
              ),
            ),
          ),
      ],
    );
  }
}

class _ZombieWidget extends StatelessWidget {
  final Zombie zombie;
  final Size screenSize;
  final int level;
  final VoidCallback onTap;

  const _ZombieWidget({
    required this.zombie,
    required this.screenSize,
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = screenSize.width * 0.15;
    final x = zombie.x * screenSize.width;
    final y = zombie.y * screenSize.height - w / 2;

    return Positioned(
      left: x - w / 2,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // Hit counter badge
            if (!zombie.dying && zombie.hitsLeft > 0)
              Positioned(
                top: -16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.red.withOpacity(.5), blurRadius: 8),
                    ],
                  ),
                  child: Text(
                    '${zombie.hitsLeft} clicks',
                    style: GoogleFonts.bangers(
                      fontSize: 14,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            // Zombie sprite
            Opacity(
              opacity: zombie.dying ? (1.0 - zombie.dyingTimer / 0.8).clamp(0, 1) : 1.0,
              child: Transform.scale(
                scale: zombie.dying ? (1.0 + zombie.dyingTimer * 0.3) : 1.0,
                child: Image.asset(
                  'assets/images/zombies/${zombie.type}.png',
                  width: w,
                  height: w * 1.4,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Text(
                    '🧟',
                    style: TextStyle(fontSize: w * 0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Boom {
  final double x, y;
  double timer = 0;
  _Boom({required this.x, required this.y});
}

class _BoomWidget extends StatelessWidget {
  final _Boom boom;
  final Size screenSize;

  const _BoomWidget({required this.boom, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    final x = boom.x * screenSize.width;
    final y = boom.y * screenSize.height;
    final scale = 1.0 + boom.timer * 1.5;
    final opacity = (1.0 - boom.timer).clamp(0.0, 1.0);
    final size = screenSize.width * 0.25;

    return Positioned(
      left: x - size / 2,
      top: y - size / 2,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Image.asset(
            'assets/images/boom/storm.png',
            width: size,
            height: size,
            errorBuilder: (_, __, ___) => Text(
              '💨',
              style: TextStyle(fontSize: size * 0.5, color: Colors.blue.shade300),
            ),
          ),
        ),
      ),
    );
  }
}

class _HUD extends StatelessWidget {
  final int level, luluLives, guteLives, score;
  final double levelTimer, levelDuration;
  final String selectedAvatar;
  final VoidCallback onBack;

  const _HUD({
    required this.level,
    required this.luluLives,
    required this.guteLives,
    required this.levelTimer,
    required this.levelDuration,
    required this.score,
    required this.selectedAvatar,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (levelTimer / levelDuration).clamp(0.0, 1.0);
    final timeLeft = (levelDuration - levelTimer).ceil();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(.2)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.4), blurRadius: 8)],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
              ),
              const SizedBox(width: 10),
              _hudChip('Nível $level', const Color(0xFFFFD700)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${timeLeft}s',
                      style: GoogleFonts.nunito(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 1.0 - progress,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress > 0.8 ? Colors.orange : const Color(0xFF00E5FF),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _hudChip('🏆 $score', const Color(0xFF98D8AA)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: _LivesBar(
                  name: 'LULU',
                  lives: luluLives,
                  color: const Color(0xFFFF6B9D),
                  isSelected: selectedAvatar == 'lulu',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _LivesBar(
                  name: 'GUTE',
                  lives: guteLives,
                  color: const Color(0xFF00E5FF),
                  isSelected: selectedAvatar == 'gute',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hudChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(.6)),
      ),
      child: Text(
        text,
        style: GoogleFonts.bangers(fontSize: 13, color: color, letterSpacing: 1),
      ),
    );
  }
}

class _LivesBar extends StatelessWidget {
  final String name;
  final int lives;
  final Color color;
  final bool isSelected;

  const _LivesBar({
    required this.name,
    required this.lives,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.white24,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(.3), blurRadius: 8)] : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: GoogleFonts.bangers(
              fontSize: 13,
              color: color,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 6),
          ...List.generate(5, (i) => Text(
            i < lives ? '❤️' : '💔',
            style: const TextStyle(fontSize: 11),
          )),
        ],
      ),
    );
  }
}

class _GameOverOverlay extends StatefulWidget {
  final int score, level;
  final VoidCallback onRestart, onHome;

  const _GameOverOverlay({
    required this.score,
    required this.level,
    required this.onRestart,
    required this.onHome,
  });

  @override
  State<_GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<_GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _anim, curve: Curves.elasticOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(.85),
      child: Center(
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a2e),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFFF4444), width: 2),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF4444).withOpacity(.4), blurRadius: 30),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🧟💀🧟', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  'GAME OVER',
                  style: GoogleFonts.bangers(
                    fontSize: 56,
                    color: const Color(0xFFFF4444),
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 24),
                _statRow('Nível alcançado', '${widget.level}', const Color(0xFFFFD700)),
                _statRow('Pontuação final', '${widget.score}', const Color(0xFF98D8AA)),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button('🏠 Home', const Color(0xFF666688), widget.onHome),
                    const SizedBox(width: 16),
                    _button('🔄 Jogar Novamente', const Color(0xFFFF6B9D), widget.onRestart),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.nunito(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w600)),
          Text(value, style: GoogleFonts.bangers(color: color, fontSize: 28, letterSpacing: 2)),
        ],
      ),
    );
  }

  Widget _button(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: color.withOpacity(.4), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
