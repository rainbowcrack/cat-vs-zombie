import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/runner_game_flame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Bloqueia a orientação apenas para vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Deixa a barra de status transparente
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
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
        title: 'Cats vs Zombies',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6B9D),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF0F8),
          textTheme: GoogleFonts.nunitoTextTheme(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Splash Screen
// ─────────────────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.0, 0.7, curve: Curves.elasticOut)));
    
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.4, 0.9, curve: Curves.easeIn)));
    
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.65, 1.0, curve: Curves.easeIn)));
    
    _ctrl.forward();
  }

  void _goToGame() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RunnerSelectScreen()),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE5F1),
              Color(0xFFFFF0F8),
              Color(0xFFE8D5F5),
              Color(0xFFD5E8FF)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      'assets/images/cat/gute_home.png',
                      errorBuilder: (_, __, ___) => const Center(
                          child: Text('🐱', style: TextStyle(fontSize: 50))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fade,
                child: Text(
                  'Cats vs Zombies',
                  style: GoogleFonts.pacifico(
                    fontSize: 32,
                    color: const Color(0xFFFF6B9D),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _taglineFade,
                child: Text(
                  'Escolha Lulu ou Gute e proteja seu par!',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: const Color(0xFFBB8EC0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _goToGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF533483),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'JOGAR AGORA',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}