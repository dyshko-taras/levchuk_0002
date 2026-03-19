import { createBrowserRouter } from 'react-router';
import { Root } from './Root';
import { SplashScreen } from './screens/SplashScreen';
import { WelcomeScreen } from './screens/WelcomeScreen';
import { HomeScreen } from './screens/HomeScreen';
import { ExerciseScreen } from './screens/ExerciseScreen';
import { CustomWorkoutScreen } from './screens/CustomWorkoutScreen';
import { AddExerciseScreen } from './screens/AddExerciseScreen';
import { CustomStepScreen } from './screens/CustomStepScreen';
import { WellnessTipsScreen } from './screens/WellnessTipsScreen';
import { TipDetailScreen } from './screens/TipDetailScreen';
import { QuotesScreen } from './screens/QuotesScreen';
import { BreathingScreen } from './screens/BreathingScreen';
import { BreathingSettingsScreen } from './screens/BreathingSettingsScreen';
import { SettingsScreen } from './screens/SettingsScreen';

export const router = createBrowserRouter([
  {
    path: '/',
    Component: Root,
    children: [
      { index: true, Component: SplashScreen },
      { path: 'welcome', Component: WelcomeScreen },
      { path: 'home', Component: HomeScreen },
      { path: 'exercise', Component: ExerciseScreen },
      { path: 'workout', Component: CustomWorkoutScreen },
      { path: 'workout/add', Component: AddExerciseScreen },
      { path: 'workout/custom-step', Component: CustomStepScreen },
      { path: 'tips', Component: WellnessTipsScreen },
      { path: 'tips/:topicId', Component: TipDetailScreen },
      { path: 'quotes', Component: QuotesScreen },
      { path: 'breathe', Component: BreathingScreen },
      { path: 'breathe/settings', Component: BreathingSettingsScreen },
      { path: 'settings', Component: SettingsScreen },
    ],
  },
]);
