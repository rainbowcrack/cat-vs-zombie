import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  static final AudioManager _instance =
      AudioManager._internal();

  factory AudioManager() => _instance;

  AudioManager._internal();

  //
  // PLAYER MÚSICA
  //
  final AudioPlayer _musicPlayer =
      AudioPlayer();

  //
  // PLAYERS SFX
  //
  final List<AudioPlayer> _sfxPlayers =
      List.generate(
    5,
    (_) => AudioPlayer(),
  );

  int _sfxIndex = 0;

  bool _muted = false;

  String? _currentMusic;

  bool get isMuted => _muted;

  //
  // MÚSICA
  //
  Future<void> playMusic(String file) async {
    if (_muted) return;

    //
    // evita reiniciar mesma música
    //
    if (_currentMusic == file) return;

    _currentMusic = file;

    await _musicPlayer.stop();

    await _musicPlayer.setReleaseMode(
      ReleaseMode.loop,
    );

    await _musicPlayer.play(
      AssetSource(_format(file)),
      volume: 1.0,
    );
  }

  //
  // SFX
  //
  Future<void> playSfx(String file) async {
    if (_muted) return;

    final player =
        _sfxPlayers[_sfxIndex];

    _sfxIndex =
        (_sfxIndex + 1) %
            _sfxPlayers.length;

    try {
      await player.stop();

      await player.play(
        AssetSource(_format(file)),
        volume: 1.0,
      );
    } catch (_) {}
  }

  //
  // MUTE
  //
  Future<void> toggleMute() async {
    _muted = !_muted;

    if (_muted) {
      await _musicPlayer.pause();

      for (final p in _sfxPlayers) {
        await p.stop();
      }
    } else {
      await _musicPlayer.resume();
    }
  }

  //
  // STOP MUSIC
  //
  Future<void> stopMusic() async {
    _currentMusic = null;

    await _musicPlayer.stop();
  }

  //
  // STOP ALL
  //
  Future<void> stopAll() async {
    _currentMusic = null;

    await _musicPlayer.stop();

    for (final p in _sfxPlayers) {
      await p.stop();
    }
  }

  //
  // DISPOSE
  //
  void dispose() {
    _musicPlayer.dispose();

    for (final p in _sfxPlayers) {
      p.dispose();
    }
  }

  //
  // WEB/MOBILE
  //
  String _format(String file) {
    if (kIsWeb) {
      return file.replaceAll(
        '.mp3',
        '.wav',
      );
    }

    return file;
  }
}