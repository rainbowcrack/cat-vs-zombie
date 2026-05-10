import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() => _instance;

  AudioManager._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _muted = false;

  bool get isMuted => _muted;

  /// inicia música em loop
  Future<void> playMusic(String file) async {
    if (_muted) return;

    await _musicPlayer.stop();

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);

    await _musicPlayer.play(
      AssetSource(_format(file)),
      volume: 1.0,
    );
  }

  /// efeitos sonoros (laser, zombie etc)
  Future<void> playSfx(String file) async {
    if (_muted) return;

    await _sfxPlayer.stop();

    await _sfxPlayer.play(
      AssetSource(_format(file)),
      volume: 1.0,
    );
  }

  /// 🔇 mute global
  Future<void> toggleMute() async {
    _muted = !_muted;

    if (_muted) {
      await _musicPlayer.pause();
      await _sfxPlayer.stop();
    } else {
      await _musicPlayer.resume();
    }
  }

  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }

  ///  helper Web/Mobile (mp3 ou wav automático)
  String _format(String file) {
    if (kIsWeb) {
      return file.replaceAll('.mp3', '.wav');
    }
    return file;
  }
}