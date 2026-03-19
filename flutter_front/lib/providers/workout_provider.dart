import 'package:flutter/foundation.dart';

import '../data/models/custom_workout.dart';
import '../data/models/exercise.dart';
import '../data/models/workout_step.dart';
import '../data/repositories/exercise_repository.dart';
import '../data/repositories/workout_repository.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
  })  : _workoutRepository = workoutRepository,
        _exerciseRepository = exerciseRepository;

  final WorkoutRepository _workoutRepository;
  final ExerciseRepository _exerciseRepository;

  bool _loaded = false;
  List<CustomWorkout> _savedWorkouts = const [];
  List<Exercise> _availableExercises = const [];
  List<WorkoutStep> _draftSteps = const [];

  bool get loaded => _loaded;
  List<CustomWorkout> get savedWorkouts => _savedWorkouts;
  List<Exercise> get availableExercises => _availableExercises;
  List<WorkoutStep> get draftSteps => _draftSteps;

  Future<void> load() async {
    if (_loaded) {
      return;
    }

    _savedWorkouts = await _workoutRepository.loadAll();
    _availableExercises = await _exerciseRepository.loadExercises();
    _loaded = true;
    notifyListeners();
  }

  void addExerciseToDraft(Exercise exercise) {
    _draftSteps = [
      ..._draftSteps,
      WorkoutStep(
        id: exercise.id,
        name: exercise.name,
        durationSeconds: exercise.durationSeconds,
        isCustom: false,
      ),
    ];
    notifyListeners();
  }

  void addCustomStep(WorkoutStep step) {
    _draftSteps = [..._draftSteps, step];
    notifyListeners();
  }

  void clearDraft() {
    _draftSteps = const [];
    notifyListeners();
  }

  Future<void> saveWorkout(CustomWorkout workout) async {
    _savedWorkouts = [..._savedWorkouts, workout];
    notifyListeners();
    await _workoutRepository.saveAll(_savedWorkouts);
  }
}
