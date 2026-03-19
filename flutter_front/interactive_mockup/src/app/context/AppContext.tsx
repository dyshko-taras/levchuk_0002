import { createContext, useContext, useState, ReactNode } from 'react';

interface AppContextType {
  currentQuoteIndex: number;
  setCurrentQuoteIndex: (i: number) => void;
  showExerciseComplete: boolean;
  setShowExerciseComplete: (v: boolean) => void;
  showBreathingComplete: boolean;
  setShowBreathingComplete: (v: boolean) => void;
  breathingPhase: 'inhale' | 'hold';
  setBreathingPhase: (v: 'inhale' | 'hold') => void;
  toggleStates: Record<string, boolean>;
  setToggle: (key: string, value: boolean) => void;
  breathDuration: number;
  setBreathDuration: (d: number) => void;
  breathMode: string;
  setBreathMode: (m: string) => void;
  breathSound: boolean;
  setBreathSound: (v: boolean) => void;
}

const AppContext = createContext<AppContextType | null>(null);

export function AppContextProvider({ children }: { children: ReactNode }) {
  const [currentQuoteIndex, setCurrentQuoteIndex] = useState(0);
  const [showExerciseComplete, setShowExerciseComplete] = useState(false);
  const [showBreathingComplete, setShowBreathingComplete] = useState(false);
  const [breathingPhase, setBreathingPhase] = useState<'inhale' | 'hold'>('inhale');
  const [toggleStates, setToggleStates] = useState<Record<string, boolean>>({
    hourlyReminders: true,
    breathingReminders: true,
    sound: false,
  });
  const [breathDuration, setBreathDuration] = useState(3);
  const [breathMode, setBreathMode] = useState('Energy');
  const [breathSound, setBreathSound] = useState(true);

  const setToggle = (key: string, value: boolean) => {
    setToggleStates(prev => ({ ...prev, [key]: value }));
  };

  return (
    <AppContext.Provider value={{
      currentQuoteIndex, setCurrentQuoteIndex,
      showExerciseComplete, setShowExerciseComplete,
      showBreathingComplete, setShowBreathingComplete,
      breathingPhase, setBreathingPhase,
      toggleStates, setToggle,
      breathDuration, setBreathDuration,
      breathMode, setBreathMode,
      breathSound, setBreathSound,
    }}>
      {children}
    </AppContext.Provider>
  );
}

export function useAppContext() {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error('useAppContext must be used within AppContextProvider');
  return ctx;
}
