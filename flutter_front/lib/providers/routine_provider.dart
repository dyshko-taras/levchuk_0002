import 'package:FlutterApp/data/models/day_progress.dart';
import 'package:FlutterApp/data/models/hourly_routine.dart';
import 'package:FlutterApp/data/models/user_progress.dart';
import 'package:FlutterApp/data/repositories/exercise_repository.dart';
import 'package:FlutterApp/data/repositories/progress_repository.dart';
import 'package:flutter/foundation.dart';

class RoutineProvider extends ChangeNotifier {
  RoutineProvider({
    required ExerciseRepository exerciseRepository,
    required ProgressRepository progressRepository,
  }) : _exerciseRepository = exerciseRepository,
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
  int get workoutSessions => todayProgress.workoutSessions;

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
      final hasActivity =
          progress.completedHours.isNotEmpty ||
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

  Future<void> addBreathingMinutes(int minutes) async {
    if (minutes <= 0) {
      return;
    }

    final updatedDay = DayProgress(
      completedHours: todayProgress.completedHours,
      breathingMinutes: todayProgress.breathingMinutes + minutes,
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

  Future<void> incrementWorkoutSessions() async {
    final updatedDay = DayProgress(
      completedHours: todayProgress.completedHours,
      breathingMinutes: todayProgress.breathingMinutes,
      workoutSessions: todayProgress.workoutSessions + 1,
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

  Future<void> clearAllProgress() async {
    _userProgress = UserProgress.empty();
    notifyListeners();
    await _progressRepository.clear();
  }

  Future<void> applyDemoData() async {
    final today = DateTime.parse(todayKey);
    final yesterdayKey = today
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .split('T')
        .first;
    final twoDaysAgoKey = today
        .subtract(const Duration(days: 2))
        .toIso8601String()
        .split('T')
        .first;

    _userProgress = UserProgress(
      dailyProgress: {
        todayKey: const DayProgress(
          completedHours: [1, 2, 3, 5],
          breathingMinutes: 9,
          workoutSessions: 1,
        ),
        yesterdayKey: const DayProgress(
          completedHours: [1, 2, 4],
          breathingMinutes: 6,
          workoutSessions: 1,
        ),
        twoDaysAgoKey: const DayProgress(
          completedHours: [2, 3],
          breathingMinutes: 3,
          workoutSessions: 0,
        ),
      },
    );
    notifyListeners();
    await _progressRepository.save(_userProgress);
  }
}
