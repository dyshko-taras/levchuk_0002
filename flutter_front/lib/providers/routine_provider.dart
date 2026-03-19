import 'package:flutter/foundation.dart';

import '../data/models/day_progress.dart';
import '../data/models/hourly_routine.dart';
import '../data/models/user_progress.dart';
import '../data/repositories/exercise_repository.dart';
import '../data/repositories/progress_repository.dart';

class RoutineProvider extends ChangeNotifier {
  RoutineProvider({
    required ExerciseRepository exerciseRepository,
    required ProgressRepository progressRepository,
  })  : _exerciseRepository = exerciseRepository,
        _progressRepository = progressRepository;

  final ExerciseRepository _exerciseRepository;
  final ProgressRepository _progressRepository;

  bool _loaded = false;
  List<HourlyRoutine> _hourlyRoutine = const [];
  UserProgress _userProgress = UserProgress.empty();

  bool get loaded => _loaded;
  List<HourlyRoutine> get hourlyRoutine => _hourlyRoutine;
  UserProgress get userProgress => _userProgress;

  String get todayKey => DateTime.now().toIso8601String().split('T').first;

  DayProgress get todayProgress =>
      _userProgress.dailyProgress[todayKey] ??
      const DayProgress(
        completedHours: [],
        breathingMinutes: 0,
        workoutSessions: 0,
      );

  int get completedHoursCount => todayProgress.completedHours.length;
  int get breathingMinutes => todayProgress.breathingMinutes;

  int get streakDays {
    final keys = _userProgress.dailyProgress.keys.toList()..sort();
    var streak = 0;
    final today = DateTime.parse(todayKey);

    for (var offset = 0; offset < keys.length; offset++) {
      final date = today.subtract(Duration(days: offset));
      final key = date.toIso8601String().split('T').first;
      final progress = _userProgress.dailyProgress[key];
      if (progress == null) {
        break;
      }
      final hasActivity = progress.completedHours.isNotEmpty ||
          progress.breathingMinutes > 0 ||
          progress.workoutSessions > 0;
      if (!hasActivity) {
        break;
      }
      streak++;
    }

    return streak;
  }

  Future<void> load() async {
    if (_loaded) {
      return;
    }

    _hourlyRoutine = await _exerciseRepository.loadHourlyRoutine();
    _userProgress = await _progressRepository.load();
    _loaded = true;
    notifyListeners();
  }

  HourlyRoutine routineForHour(int hour) {
    return _hourlyRoutine.firstWhere(
      (item) => item.hour == hour,
      orElse: () => _hourlyRoutine.first,
    );
  }

  bool isHourCompleted(int hour) => todayProgress.completedHours.contains(hour);

  String statusEmojiForHour(int hour) {
    if (isHourCompleted(hour)) {
      return '✅';
    }
    return '⏳';
  }

  Future<void> markHourCompleted(int hour) async {
    final completed = {...todayProgress.completedHours, hour}.toList()..sort();
    final updatedDay = DayProgress(
      completedHours: completed,
      breathingMinutes: todayProgress.breathingMinutes,
      workoutSessions: todayProgress.workoutSessions,
    );
    _userProgress = UserProgress(
      dailyProgress: {
        ..._userProgress.dailyProgress,
        todayKey: updatedDay,
      },
    );
    notifyListeners();
    await _progressRepository.save(_userProgress);
  }

  Future<void> resetToday() async {
    final updated = Map<String, DayProgress>.from(_userProgress.dailyProgress)
      ..remove(todayKey);
    _userProgress = UserProgress(dailyProgress: updated);
    notifyListeners();
    await _progressRepository.save(_userProgress);
  }
}
