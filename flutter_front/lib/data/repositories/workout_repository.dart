import 'dart:convert';

import 'package:FlutterApp/data/local/prefs_store.dart';
import 'package:FlutterApp/data/models/custom_workout.dart';

class WorkoutRepository {
  WorkoutRepository({
    PrefsStore? prefsStore,
  }) : _prefsStore = prefsStore ?? PrefsStore.instance;

  final PrefsStore _prefsStore;

  Future<List<CustomWorkout>> loadAll() async {
    final raw = await _prefsStore.readString(PrefKeys.customWorkouts);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => CustomWorkout.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<CustomWorkout> workouts) async {
    await _prefsStore.saveString(
      PrefKeys.customWorkouts,
      jsonEncode(workouts.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    await _prefsStore.remove(PrefKeys.customWorkouts);
  }
}
