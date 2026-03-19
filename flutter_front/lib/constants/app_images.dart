abstract final class AppImages {
  static const homeHero = 'assets/images/heroes/home_hero.webp';
  static const welcomeHero = 'assets/images/heroes/welcome_hero.webp';
  static const workoutHero = 'assets/images/heroes/workout_hero.webp';
  static const breathingBackground =
      'assets/images/backgrounds/breathing_bg.webp';
  static const quotesBackground = 'assets/images/backgrounds/quotes_bg.webp';
  static const tipEye = 'assets/images/tips/tip_eye.webp';
  static const tipPosture = 'assets/images/tips/tip_posture.webp';
  static const tipStress = 'assets/images/tips/tip_stress.webp';
  static const tipFocus = 'assets/images/tips/tip_focus.webp';
  static const tipHydration = 'assets/images/tips/tip_hydration.webp';
  static const tipSleep = 'assets/images/tips/tip_sleep.webp';
  static const tipMental = 'assets/images/tips/tip_mental.webp';
  static const tipMobility = 'assets/images/tips/tip_mobility.webp';
  static const tipProductivity = 'assets/images/tips/tip_productivity.webp';
  static const tipBreathing = 'assets/images/tips/tip_breathing.webp';

  static String topicImage(String topicId) {
    switch (topicId) {
      case 'eye_tips':
        return tipEye;
      case 'posture_tips':
        return tipPosture;
      case 'stress_tips':
        return tipStress;
      case 'focus_fatigue':
        return tipFocus;
      case 'hydration_nutrition':
        return tipHydration;
      case 'sleep_recovery':
        return tipSleep;
      case 'mental_health':
        return tipMental;
      case 'mobility_stretching':
        return tipMobility;
      case 'productivity_balance':
        return tipProductivity;
      case 'breathing_relaxation':
        return tipBreathing;
      default:
        return homeHero;
    }
  }
}
