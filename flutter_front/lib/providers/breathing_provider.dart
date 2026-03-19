import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/breathing_settings.dart';
import '../data/repositories/breathing_settings_repository.dart';
import '../enums/enums.dart';
import 'routine_provider.dart';

class BreathingProvider extends ChangeNotifier {
  BreathingProvider({
    required BreathingSettingsRepository repository,
    required RoutineProvider routineProvider,
  }) : _repository = repository,
       _routineProvider = routineProvider;

  final BreathingSettingsRepository _repository;
  final RoutineProvider _routineProvider;

  bool _loaded = false;
  BreathingSettings _settings = BreathingSettings.defaults();
  Timer? _timer;
  BreathingPhase _phase = BreathingPhase.idle;
  bool _sessionRunning = false;
  bool _sessionCompleted = false;
  bool _progressRecorded = false;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  int _phaseRemainingSeconds = 0;
  int _phaseDurationSeconds = 0;
  int _currentCycle = 1;

  bool get loaded => _loaded;
  BreathingSettings get settings => _settings;
  BreathingPhase get phase => _phase;
  bool get sessionRunning => _sessionRunning;
  bool get sessionCompleted => _sessionCompleted;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  int get currentCycle => _currentCycle;

  int get totalCycles {
    final cycleDuration = _cycleDurationForMode(_settings.mode);
    return cycleDuration == 0 ? 1 : (_totalSeconds / cycleDuration).ceil();
  }

  String get phaseLabel {
    switch (_phase) {
      case BreathingPhase.inhale:
        return 'Inhale...';
      case BreathingPhase.holdIn:
        return 'Hold...';
      case BreathingPhase.exhale:
        return 'Exhale...';
      case BreathingPhase.holdOut:
        return 'Rest...';
      case BreathingPhase.completed:
        return 'Complete';
      case BreathingPhase.idle:
        return 'Ready';
    }
  }

  double get phaseProgress {
    if (_phaseDurationSeconds <= 0) {
      return 1;
    }
    final completed = _phaseDurationSeconds - _phaseRemainingSeconds;
    return (completed / _phaseDurationSeconds).clamp(0, 1);
  }

  double get circleScale {
    switch (_phase) {
      case BreathingPhase.inhale:
        return 0.42 + (0.46 * phaseProgress);
      case BreathingPhase.holdIn:
        return 0.88;
      case BreathingPhase.exhale:
        return 0.88 - (0.46 * phaseProgress);
      case BreathingPhase.holdOut:
        return 0.42;
      case BreathingPhase.completed:
        return 0.88;
      case BreathingPhase.idle:
        return 0.52;
    }
  }

  Future<void> load() async {
    _settings = await _repository.load();
    _loaded = true;
    notifyListeners();
  }

  Future<void> update(BreathingSettings settings) async {
    _settings = settings;
    if (!_sessionRunning && !_sessionCompleted) {
      _resetSessionState();
    }
    notifyListeners();
    await _repository.save(settings);
  }

  Future<void> updateDuration(int minutes) async {
    await update(
      BreathingSettings(
        durationMinutes: minutes,
        mode: _settings.mode,
        soundEnabled: _settings.soundEnabled,
      ),
    );
  }

  Future<void> updateMode(BreathingMode mode) async {
    await update(
      BreathingSettings(
        durationMinutes: _settings.durationMinutes,
        mode: mode,
        soundEnabled: _settings.soundEnabled,
      ),
    );
  }

  Future<void> updateSound(bool enabled) async {
    await update(
      BreathingSettings(
        durationMinutes: _settings.durationMinutes,
        mode: _settings.mode,
        soundEnabled: enabled,
      ),
    );
  }

  Future<void> applyReminderPreset() async {
    await update(
      const BreathingSettings(
        durationMinutes: 3,
        mode: BreathingMode.focus,
        soundEnabled: true,
      ),
    );
  }

  void startSession() {
    if (_sessionRunning) {
      return;
    }
    if (_remainingSeconds <= 0 ||
        _sessionCompleted ||
        _phase == BreathingPhase.idle) {
      _beginFreshSession();
    }
    _sessionRunning = true;
    _sessionCompleted = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void pauseSession() {
    if (!_sessionRunning) {
      return;
    }
    _timer?.cancel();
    _sessionRunning = false;
    notifyListeners();
  }

  void restartSession() {
    _beginFreshSession();
    startSession();
  }

  void stopSession() {
    _timer?.cancel();
    _resetSessionState();
    notifyListeners();
  }

  void dismissCompletion() {
    _sessionCompleted = false;
    notifyListeners();
  }

  void _beginFreshSession() {
    _timer?.cancel();
    _sessionRunning = false;
    _sessionCompleted = false;
    _progressRecorded = false;
    _totalSeconds = _settings.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _currentCycle = 1;
    _setPhase(BreathingPhase.inhale);
  }

  void _tick() {
    if (_remainingSeconds <= 1) {
      _completeSession();
      return;
    }

    _remainingSeconds--;
    _phaseRemainingSeconds--;

    if (_phaseRemainingSeconds <= 0) {
      _advancePhase();
    }

    final cycleDuration = _cycleDurationForMode(_settings.mode);
    if (cycleDuration > 0) {
      _currentCycle =
          ((_totalSeconds - _remainingSeconds) / cycleDuration).floor() + 1;
      if (_currentCycle > totalCycles) {
        _currentCycle = totalCycles;
      }
    }

    notifyListeners();
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    _remainingSeconds = 0;
    _sessionRunning = false;
    _sessionCompleted = true;
    _phase = BreathingPhase.completed;
    _phaseRemainingSeconds = 0;
    _phaseDurationSeconds = 0;
    if (!_progressRecorded) {
      _progressRecorded = true;
      await _routineProvider.addBreathingMinutes(_settings.durationMinutes);
    }
    notifyListeners();
  }

  void _advancePhase() {
    switch (_phase) {
      case BreathingPhase.inhale:
        _setPhase(BreathingPhase.holdIn);
      case BreathingPhase.holdIn:
        _setPhase(BreathingPhase.exhale);
      case BreathingPhase.exhale:
        _setPhase(BreathingPhase.holdOut);
      case BreathingPhase.holdOut:
        _setPhase(BreathingPhase.inhale);
      case BreathingPhase.completed:
      case BreathingPhase.idle:
        _setPhase(BreathingPhase.inhale);
    }
  }

  void _setPhase(BreathingPhase phase) {
    _phase = phase;
    _phaseDurationSeconds = _durationForPhase(phase);
    _phaseRemainingSeconds = _phaseDurationSeconds;
  }

  void _resetSessionState() {
    _phase = BreathingPhase.idle;
    _sessionRunning = false;
    _sessionCompleted = false;
    _progressRecorded = false;
    _remainingSeconds = 0;
    _totalSeconds = 0;
    _phaseRemainingSeconds = 0;
    _phaseDurationSeconds = 0;
    _currentCycle = 1;
  }

  int _cycleDurationForMode(BreathingMode mode) {
    final phases = _durationsForMode(mode);
    return phases.values.fold<int>(0, (sum, value) => sum + value);
  }

  int _durationForPhase(BreathingPhase phase) {
    final durations = _durationsForMode(_settings.mode);
    switch (phase) {
      case BreathingPhase.inhale:
        return durations[BreathingPhase.inhale]!;
      case BreathingPhase.holdIn:
        return durations[BreathingPhase.holdIn]!;
      case BreathingPhase.exhale:
        return durations[BreathingPhase.exhale]!;
      case BreathingPhase.holdOut:
        return durations[BreathingPhase.holdOut]!;
      case BreathingPhase.completed:
      case BreathingPhase.idle:
        return 0;
    }
  }

  Map<BreathingPhase, int> _durationsForMode(BreathingMode mode) {
    switch (mode) {
      case BreathingMode.calm:
        return const {
          BreathingPhase.inhale: 4,
          BreathingPhase.holdIn: 4,
          BreathingPhase.exhale: 6,
          BreathingPhase.holdOut: 2,
        };
      case BreathingMode.energy:
        return const {
          BreathingPhase.inhale: 3,
          BreathingPhase.holdIn: 1,
          BreathingPhase.exhale: 3,
          BreathingPhase.holdOut: 1,
        };
      case BreathingMode.focus:
        return const {
          BreathingPhase.inhale: 3,
          BreathingPhase.holdIn: 2,
          BreathingPhase.exhale: 4,
          BreathingPhase.holdOut: 2,
        };
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

enum BreathingPhase {
  idle,
  inhale,
  holdIn,
  exhale,
  holdOut,
  completed,
}
