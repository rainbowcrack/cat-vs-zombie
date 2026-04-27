import 'package:flutter/foundation.dart';

class GameProvider extends ChangeNotifier {
  final CatModel cat = CatModel();

  String? message;
  String currentScene = 'home';

  GameProvider() {
    _updateMessage();
  }

  void setScene(String scene) {
    currentScene = scene;
    _updateMessage();
    notifyListeners();
  }

  void playCat() {
    cat.hunger = (cat.hunger - 5).clamp(0, 100);
    cat.energy = (cat.energy + 8).clamp(0, 100);
    cat.happiness = (cat.happiness + 5).clamp(0, 100);
    cat.coins += 1;
    _updateMessage();
    notifyListeners();
  }

  void _updateMessage() {
    if (cat.hunger < 25) {
      message = 'Estou com fome...';
    } else if (cat.energy < 25) {
      message = 'Cansada, por favor...';
    } else if (cat.happiness < 25) {
      message = 'Vamos brincar!';
    } else {
      message = null;
    }
  }
}

class CatModel {
  int level = 1;
  int coins = 0;
  double hunger = 90;
  double happiness = 85;
  double energy = 80;

  String get alertSpeech {
    if (hunger < 25) return 'Estou com fome...';
    if (energy < 25) return 'Estou cansada...';
    if (happiness < 25) return 'Vamos brincar!';
    return '';
  }

  String catAsset(String scene) {
    switch (scene.toLowerCase()) {
      case 'home':
        return 'assets/images/cat/gute_home.png';
      case 'kitchen':
      case 'bedroom':
      case 'outdoor':
      case 'classroom':
      case 'walk':
      case 'minigame':
        return 'assets/images/cat/gute_home.png';
      default:
        return 'assets/images/cat/gute_home.png';
    }
  }
}
