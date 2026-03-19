abstract final class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const home = '/home';
  static const tips = '/tips';
  static const breathe = '/breathe';
  static const quotes = '/quotes';
  static const workout = '/workout';
  static const settings = '/settings';
  static const exercise = '/exercise';
  static const addExercise = '/workout/add-exercise';
  static const customStep = '/workout/custom-step';
  static const breathingSettings = '/breathe/settings';

  static String exerciseForHour(int hour) => '$exercise/$hour';
  static String tipDetail(String topicId) => '/tips/$topicId';
}
