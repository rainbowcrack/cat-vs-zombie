import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreEntry {
  final int score;
  final DateTime playedAt;

  const ScoreEntry({
    required this.score,
    required this.playedAt,
  });

  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      score: json['score'] as int? ?? 0,
      playedAt: DateTime.tryParse(json['playedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'playedAt': playedAt.toIso8601String(),
    };
  }
}

class ScoreHistory {
  static const _key = 'score_history';
  static const _maxSavedScores = 10;

  static Future<void> addScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getScores();

    final updated = [
      ScoreEntry(score: score, playedAt: DateTime.now()),
      ...entries,
    ].take(_maxSavedScores).toList();

    await prefs.setStringList(
      _key,
      updated.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }

  static Future<List<ScoreEntry>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final storedScores = prefs.getStringList(_key) ?? const [];
    final entries = <ScoreEntry>[];

    for (final storedScore in storedScores) {
      try {
        final decoded = jsonDecode(storedScore) as Map<String, dynamic>;
        entries.add(ScoreEntry.fromJson(decoded));
      } catch (e) {
        debugPrint('Score invalido ignorado: $e');
      }
    }

    entries.sort((a, b) => b.playedAt.compareTo(a.playedAt));
    return entries;
  }
}
