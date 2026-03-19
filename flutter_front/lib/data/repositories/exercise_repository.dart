import '../local/asset_loader.dart';
import '../models/exercise.dart';
import '../models/hourly_routine.dart';

class ExerciseRepository {
  ExerciseRepository({
    AssetLoader? assetLoader,
  }) : _assetLoader = assetLoader ?? const AssetLoader();

  static const _assetPath = 'assets/data/hourly_exercises.json';
  final AssetLoader _assetLoader;

  Future<List<Exercise>> loadExercises() async {
    final rawList = await _assetLoader.loadList(_assetPath);
    return rawList
        .map((item) => Exercise.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<HourlyRoutine>> loadHourlyRoutine() async {
    final exercises = await loadExercises();
    const labels = [
      ('1st Hour', 'Start Strong'),
      ('2nd Hour', 'Stay Loose'),
      ('3rd Hour', 'Midday Focus'),
      ('4th Hour', 'Posture Reset'),
      ('5th Hour', 'Energy Boost'),
      ('6th Hour', 'Mobility Break'),
      ('7th Hour', 'Afternoon Reset'),
      ('8th Hour', 'Finish Well'),
    ];

    return List.generate(8, (index) {
      return HourlyRoutine(
        hour: index + 1,
        label: labels[index].$1,
        sublabel: labels[index].$2,
        exercise: exercises[index % exercises.length],
      );
    });
  }
}
