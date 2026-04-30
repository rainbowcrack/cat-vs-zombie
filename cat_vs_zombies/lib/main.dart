import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/runner_game_flame.dart';
import 'screens/select_avatar.dart';
import 'screens/tutorial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const GuteLearningApp());
}

class GuteLearningApp extends StatelessWidget {
  const GuteLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cats vs Zombies',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 🎮 SPLASH / HOME
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool soundOn = true;

  void _goToGame() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SelectAvatarScreen()),
    );
  }

  void _goToTutorial() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TutorialScreen()),
    );
  }

  void _toggleSound() {
    setState(() => soundOn = !soundOn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final buttonWidth = size.width * 0.22;
    final buttonHeight = size.height * 0.10;
    final fontSize = size.width * 0.018;
    final iconSize = size.width * 0.025;

    return Scaffold(
      body: Stack(
        children: [
          /// 🖼️ BACKGROUND
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/home.png'),
              fit: BoxFit.cover,
            ),
          ),

          /// 🔊 SOM
          Positioned(
            top: size.height * 0.05,
            right: size.width * 0.03,
            child: GestureDetector(
              onTap: _toggleSound,
              child: Container(
                padding: EdgeInsets.all(size.width * 0.012),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  soundOn ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
          ),

          /// 🎮 BOTÕES
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ▶️ JOGAR
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: _goToGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'JOGAR',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: size.width * 0.03),

                  /// 📘 TUTORIAL
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: OutlinedButton(
                      onPressed: _goToTutorial,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'TUTORIAL',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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