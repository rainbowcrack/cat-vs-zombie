import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/select_avatar.dart';

import 'audio/audio_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const GuteLearningApp());
}

class GuteLearningApp extends StatelessWidget {
  const GuteLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cats vs Zombies',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SplashScreen(),
    );
  }
}

//
// HOME
//
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  final AudioManager _audio = AudioManager();

  bool soundOn = true;

  @override
  void initState() {
    super.initState();

    soundOn = !_audio.isMuted;

    _startMusic();
  }

  //
  // MÚSICA HOME
  //
  Future<void> _startMusic() async {
    try {
      await _audio.playMusic(
        'audio/start.mp3',
      );
    } catch (e) {
      debugPrint(
        'Audio error (ignorado): $e',
      );
    }
  }

  //
  // IR PARA GAME
  //
  void _goToGame() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            const SelectAvatarScreen(),
      ),
    );
  }

  //
  // MUTE GLOBAL
  //
  Future<void> _toggleSound() async {
    try {
      await _audio.toggleMute();

      setState(() {
        soundOn = !_audio.isMuted;
      });
    } catch (e) {
      debugPrint(
        'Audio toggle error: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(
      context,
    );

    return Scaffold(
      body: Stack(
        children: [
          //
          // BACKGROUND
          //
          const Positioned.fill(
            child: Image(
              image: AssetImage(
                'assets/images/home.png',
              ),
              fit: BoxFit.cover,
            ),
          ),

          //
          // BOTÃO SOM
          //
          Positioned(
            top: size.height * 0.05,
            right: size.width * 0.03,
            child: GestureDetector(
              onTap: _toggleSound,
              child: Container(
                padding: EdgeInsets.all(
                  size.width * 0.012,
                ),
                decoration:
                    const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  soundOn
                      ? Icons.volume_up
                      : Icons.volume_off,
                  color: Colors.white,
                  size: size.width * 0.025,
                ),
              ),
            ),
          ),

          //
          // BOTÃO JOGAR
          //
          Align(
            alignment:
                Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom:
                    size.height * 0.05,
              ),
              child: SizedBox(
                width: size.width * 0.24,
                height:
                    size.height * 0.10,
                child: ElevatedButton(
                  onPressed: _goToGame,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.black54,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                    ),
                  ),
                  child: Text(
                    'JOGAR',
                    style: TextStyle(
                      fontSize:
                          size.width *
                              0.018,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.white,
                    ),
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