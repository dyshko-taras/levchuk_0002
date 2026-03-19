import 'dart:convert';

import 'package:FlutterApp/data/local/prefs_store.dart';
import 'package:FlutterApp/data/models/user_progress.dart';

class ProgressRepository {
  ProgressRepository({
    PrefsStore? prefsStore,
  }) : _prefsStore = prefsStore ?? PrefsStore.instance;

  final PrefsStore _prefsStore;

  Future<UserProgress> load() async {
    final raw = await _prefsStore.readString(PrefKeys.userProgress);
    if (raw == null || raw.isEmpty) {
      return UserProgress.empty();
    }

    return UserProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(UserProgress progress) async {
    await _prefsStore.saveString(
      PrefKeys.userProgress,
      jsonEncode(progress.toJson()),
    );
  }

  Future<void> clear() async {
    await _prefsStore.remove(PrefKeys.userProgress);
  }
}
