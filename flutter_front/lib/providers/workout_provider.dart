import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/custom_workout.dart';
import '../data/models/exercise.dart';
import '../data/models/workout_step.dart';
import '../data/repositories/exercise_repository.dart';
import '../data/repositories/workout_repository.dart';
import 'routine_provider.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
    required RoutineProvider routineProvider,
  }) : _workoutRepository = workoutRepository,
       _exerciseRepository = exerciseRepository,
       _routineProvider = routineProvider;

  final WorkoutRepository _workoutRepository;
  final ExerciseRepository _exerciseRepository;
  final RoutineProvider _routineProvider;

  bool _loaded = false;
  List<CustomWorkout> _savedWorkouts = const [];
  List<Exercise> _availableExercises = const [];
  List<WorkoutStep> _draftSteps = const [];
  String _searchQuery = '';
  Set<String> _selectedExerciseIds = <String>{};
  Timer? _sessionTimer;
  List<WorkoutStep> _sessionSteps = const [];
  int _sessionIndex = 0;
  int _sessionRemainingSeconds = 0;
  bool _sessionRunning = false;
  bool _sessionCompleted = false;
  bool _progressRecorded = false;

  bool get loaded => _loaded;
  List<CustomWorkout> get savedWorkouts => _savedWorkouts;
  List<Exercise> get availableExercises => _availableExercises;
  List<WorkoutStep> get draftSteps => _draftSteps;
  String get searchQuery => _searchQuery;
  bool get hasDraft => _draftSteps.isNotEmpty;

  List<Exercise> get filteredExercises {
    if (_searchQuery.trim().isEmpty) {
      return _availableExercises;
    }
    final normalized = _searchQuery.trim().toLowerCase();
    return _availableExercises
        .where((exercise) => exercise.name.toLowerCase().contains(normalized))
        .toList();
  }

  int get draftTotalSeconds => _draftSteps.fold<int>(
    0,
    (total, step) => total + step.durationSeconds,
  );

  bool get sessionRunning => _sessionRunning;
  bool get sessionCompleted => _sessionCompleted;
  bool get hasSession => _sessionSteps.isNotEmpty;
  int get sessionIndex => _sessionIndex;
  int get sessionRemainingSeconds => _sessionRemainingSeconds;
  int get sessionStepCount => _sessionSteps.length;
  WorkoutStep? get currentSessionStep =>
      _sessionSteps.isEmpty ? null : _sessionSteps[_sessionIndex];

  Future<void> load() async {
    _savedWorkouts = await _workoutRepository.loadAll();
    _availableExercises = await _exerciseRepository.loadExercises();
    _loaded = true;
    notifyListeners();
  }

  void addExerciseToDraft(Exercise exercise) {
    _draftSteps = [
      ..._draftSteps,
      WorkoutStep(
        id: '${exercise.id}-${DateTime.now().microsecondsSinceEpoch}',
        name: exercise.name,
        durationSeconds: exercise.durationSeconds,
        isCustom: false,
      ),
    ];
    notifyListeners();
  }

  bool isExerciseSelected(String exerciseId) =>
      _selectedExerciseIds.contains(exerciseId);

  void setSearchQuery(String value) {
    if (_searchQuery == value) {
      return;
    }
    _searchQuery = value;
    notifyListeners();
  }

  void toggleExerciseSelection(Exercise exercise) {
    final next = <String>{..._selectedExerciseIds};
    if (!next.add(exercise.id)) {
      next.remove(exercise.id);
    }
    _selectedExerciseIds = next;
    notifyListeners();
  }

  void commitSelectedExercises() {
    if (_selectedExerciseIds.isEmpty) {
      return;
    }

    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final steps = _availableExercises
        .where((exercise) => _selectedExerciseIds.contains(exercise.id))
        .map(
          (exercise) => WorkoutStep(
            id: '${exercise.id}-$timestamp',
            name: exercise.name,
            durationSeconds: exercise.durationSeconds,
            isCustom: false,
          ),
        )
        .toList();

    _draftSteps = [..._draftSteps, ...steps];
    _selectedExerciseIds = <String>{};
    _searchQuery = '';
    notifyListeners();
  }

  void addCustomStep(WorkoutStep step) {
    _draftSteps = [..._draftSteps, step];
    notifyListeners();
  }

  void removeDraftStepAt(int index) {
    if (index < 0 || index >= _draftSteps.length) {
      return;
    }
    final updated = [..._draftSteps]..removeAt(index);
    _draftSteps = updated;
    notifyListeners();
  }

  void clearDraft() {
    _draftSteps = const [];
    _selectedExerciseIds = <String>{};
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> saveWorkout(CustomWorkout workout) async {
    _savedWorkouts = [..._savedWorkouts, workout];
    notifyListeners();
    await _workoutRepository.saveAll(_savedWorkouts);
  }

  Future<void> saveDraftAs(String name) async {
    final workout = CustomWorkout(
      id: 'workout-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      steps: [..._draftSteps],
      createdAt: DateTime.now(),
    );
    await saveWorkout(workout);
  }

  void startDraftSession() {
    if (_draftSteps.isEmpty) {
      return;
    }
    _startSession(_draftSteps);
  }

  void pauseSession() {
    if (!_sessionRunning) {
      return;
    }
    _sessionTimer?.cancel();
    _sessionRunning = false;
    notifyListeners();
  }

  void resumeSession() {
    if (_sessionSteps.isEmpty || _sessionRunning) {
      return;
    }
    _sessionRunning = true;
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void restartSession() {
    if (_sessionSteps.isEmpty) {
      _startSession(_draftSteps);
      return;
    }
    _startSession(_sessionSteps);
  }

  void nextSessionStep() {
    if (_sessionSteps.isEmpty) {
      return;
    }
    if (_sessionIndex >= _sessionSteps.length - 1) {
      _completeSession();
      return;
    }
    _sessionIndex++;
    _sessionRemainingSeconds = _sessionSteps[_sessionIndex].durationSeconds;
    notifyListeners();
  }

  void previousSessionStep() {
    if (_sessionSteps.isEmpty || _sessionIndex == 0) {
      return;
    }
    _sessionIndex--;
    _sessionRemainingSeconds = _sessionSteps[_sessionIndex].durationSeconds;
    notifyListeners();
  }

  void stopSession() {
    _sessionTimer?.cancel();
    _sessionSteps = const [];
    _sessionIndex = 0;
    _sessionRemainingSeconds = 0;
    _sessionRunning = false;
    _sessionCompleted = false;
    _progressRecorded = false;
    notifyListeners();
  }

  void dismissCompletion() {
    _sessionCompleted = false;
    notifyListeners();
  }

  Future<void> clearAll() async {
    stopSession();
    _savedWorkouts = const [];
    _draftSteps = const [];
    notifyListeners();
    await _workoutRepository.clear();
  }

  void _startSession(List<WorkoutStep> steps) {
    if (steps.isEmpty) {
      return;
    }
    _sessionTimer?.cancel();
    _sessionSteps = [...steps];
    _sessionIndex = 0;
    _sessionRemainingSeconds = _sessionSteps.first.durationSeconds;
    _sessionCompleted = false;
    _progressRecorded = false;
    _sessionRunning = true;
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void _tick() {
    if (_sessionRemainingSeconds <= 1) {
      if (_sessionIndex >= _sessionSteps.length - 1) {
        _completeSession();
      } else {
        _sessionIndex++;
        _sessionRemainingSeconds = _sessionSteps[_sessionIndex].durationSeconds;
        notifyListeners();
      }
      return;
    }

    _sessionRemainingSeconds--;
    notifyListeners();
  }

  Future<void> _completeSession() async {
    _sessionTimer?.cancel();
    _sessionRunning = false;
    _sessionCompleted = true;
    _sessionRemainingSeconds = 0;
    if (!_progressRecorded) {
      _progressRecorded = true;
      await _routineProvider.incrementWorkoutSessions();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }
}
