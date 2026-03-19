# ActiveOffice Flutter Implementation Plan

## 1. Purpose

This document defines the implementation plan for the ActiveOffice Flutter app.
It translates the design source from `interactive_mockup/`, the product requirements from `docs/technical_spec.md`, and the global engineering rules from `docs/guidelines_provider.md` into a concrete delivery plan.

Normative priority for implementation decisions:

1. `interactive_mockup/` for visual design, composition, styling, and UI mood
2. `docs/technical_spec.md` for behavior, data, navigation rules, persistence, and feature scope
3. This implementation plan
4. `docs/guidelines_provider.md`

Conflict resolution rule:

- If the conflict is visual or compositional, the mockup wins.
- If the conflict is behavioral, architectural, or data-related, `technical_spec.md` wins.

---

## 2. Delivery Goals

The implementation must deliver:

- Full Flutter app structure from a currently minimal starter app.
- Early integration of debug-only `device_preview` plumbing so it is built into the app architecture from the beginning.
- UI that matches the visual language and screen composition of `interactive_mockup`.
- Logic and persistence that match `technical_spec.md`.
- Provider-based architecture consistent with `guidelines_provider.md`.
- Production-safe local-only behavior with no seeded mock progress data.

Non-goals for the first implementation pass:

- Remote API integration.
- Account/auth flows.
- Analytics.
- Background services beyond local reminder scheduling required by the spec.

---

## 3. Source Mapping

### Primary design source of truth

- `interactive_mockup/src/app/screens/*`
- `interactive_mockup/src/app/components/*`
- `interactive_mockup/src/styles/theme.css`
- `interactive_mockup/public/images/*`

### Functional source of truth

- `docs/technical_spec.md`

### Architecture/style constraints

- `docs/guidelines_provider.md`
- `docs/device_preview.md`
- `audit_guides/asset_guide.md`

### Important interpretation rule

The React mockup is treated as the primary visual source of truth and interaction-shape reference, but not as a complete logic source.
Hardcoded values in the mockup must be replaced with real Flutter state, asset-driven content, and persisted local data.

---

## 4. Target Flutter Architecture

The implementation will follow the Provider-based structure from `guidelines_provider.md`, adapted for this app.

Planned top-level structure:

```text
lib/
├── app.dart
├── main.dart
├── constants/
│   ├── app_config.dart
│   ├── app_routes.dart
│   ├── app_strings.dart
│   ├── app_images.dart
│   ├── app_icons.dart
│   ├── app_spacing.dart
│   ├── app_radius.dart
│   ├── app_sizes.dart
│   └── app_durations.dart
├── core/
│   ├── app_lifecycle_observer.dart
│   ├── notifications/
│   └── routing/
├── data/
│   ├── local/
│   │   ├── prefs_store.dart
│   │   ├── asset_loader.dart
│   │   └── notification_scheduler.dart
│   ├── models/
│   └── repositories/
├── enums/
│   └── enums.dart
├── providers/
├── ui/
│   ├── pages/
│   ├── theme/
│   └── widgets/
└── utils/
```

Architecture rules:

- UI widgets remain presentation-focused.
- Business logic lives in `ChangeNotifier` providers.
- Data access and persistence are encapsulated in repositories and local services.
- All app-wide constants, strings, image paths, spacing, durations, and radii are centralized.
- Repeated UI patterns are extracted into reusable widgets.
- `device_preview` support is planned from the start, but enabled only in debug builds and controlled per `docs/device_preview.md`.
- Lint cleanup is intentionally deferred until the app is functionally complete.

---

## 5. State Management Plan

Provider granularity will be domain-based, not page-based.

### Planned providers

#### `AppBootstrapProvider`

Responsibilities:

- Initialize app dependencies.
- Load first-launch flag and initial local state.
- Decide initial navigation target after splash.
- Coordinate one-time startup tasks.

#### `RoutineProvider`

Responsibilities:

- Load bundled hourly exercises.
- Build the 8-hour routine mapping.
- Track current exercise session state for hourly routines.
- Mark completed hours.
- Reset current day progress.
- Expose derived Home screen metrics.

Used by:

- Home
- Exercise
- Quick stretch action

#### `BreathingProvider`

Responsibilities:

- Store breathing settings: duration, mode, sound.
- Run breathing session timer and phase transitions.
- Compute cycles from selected mode/duration.
- Persist breathing settings immediately.
- Write breathing minutes to user progress on completion.

Used by:

- Breathe
- Breathing settings

#### `WorkoutProvider`

Responsibilities:

- Load bundled exercises for selection.
- Manage current workout draft.
- Add/remove predefined exercises.
- Add validated custom steps.
- Save custom workouts.
- Run custom routine session state.
- Increment workout sessions on completion.

Used by:

- Workout
- Add exercise
- Custom step
- Workout runner flow

#### `TipsProvider`

Responsibilities:

- Load topics and tips from bundled JSON.
- Provide topic list and topic detail lookup.
- Provide random tip-of-the-day target for Home quick action.

Used by:

- Tips list
- Tip detail
- Home quick actions

#### `QuotesProvider`

Responsibilities:

- Load bundled quotes from JSON.
- Provide quote of the day.
- Rotate to next quote.
- Maintain optionally viewed history in memory or persisted local history if needed by final scope.

Used by:

- Home
- Quotes

#### `SettingsProvider`

Responsibilities:

- Persist app settings immediately.
- Manage hourly reminders, breathing reminders, and sound.
- Own device preview debug setting per `docs/device_preview.md`.
- Coordinate permission state refresh on app resume.
- Trigger notification rationale and scheduling requests through services.

Used by:

- Settings
- Any feature needing global sound/reminder settings

#### `ShellNavigationProvider`

Responsibilities:

- Track current bottom-tab index.
- Support shell navigation and Home fallback behavior for system back handling on tab pages.

This provider should remain navigation-state only and not absorb feature logic.

---

## 6. Data and Persistence Plan

### Bundled assets

The following local JSON assets will be added under `assets/` and registered in `pubspec.yaml`:

- `assets/data/hourly_exercises.json`
- `assets/data/tips.json`
- `assets/data/quotes.json`

The asset folder will be finalized at the beginning of implementation so it does not require structural rework later.

Planned asset layout:

- `assets/data/`
- `assets/images/`
- `assets/images/backgrounds/`
- `assets/images/buttons/`
- `assets/icon/`
- `assets/fonts/`

All asset loading goes through a dedicated local service, not directly from pages.

### Persistence technology

Primary persistence:

- `shared_preferences`

Stored domains:

- `is_first_launch`
- user progress
- user settings
- breathing settings
- custom workouts
- optional quote history if retained

### Model strategy

Data models will be represented as app-specific Dart models in `lib/data/models/`.

Because `guidelines_provider.md` requires `json_serializable` for models, persisted/asset-backed models will use `json_serializable` rather than ad-hoc maps.

Expected model set:

- `exercise.dart`
- `hourly_routine.dart`
- `workout_step.dart`
- `custom_workout.dart`
- `wellness_topic.dart`
- `wellness_tip.dart`
- `quote.dart`
- `day_progress.dart`
- `user_progress.dart`
- `user_settings.dart`
- `breathing_settings.dart`

### Persistence rules

- First launch starts with empty user-generated state.
- No mock user progress may be written during bootstrap.
- All settings and user-generated changes are written immediately.
- Reset Progress clears only user-generated content required by the spec.
- `is_first_launch` and app settings survive Reset Progress.

---

## 7. Routing and Navigation Plan

The technical spec asks for `go_router` + shell behavior, while `guidelines_provider.md` describes centralized route constants and a shell page pattern.

Implementation decision:

- Use `go_router` as required by the technical spec.
- Keep route names centralized in `constants/app_routes.dart`.
- Implement a shell container with bottom navigation for the 6 main tabs.

### Main tab routes

- `/home`
- `/tips`
- `/breathe`
- `/quotes`
- `/workout`
- `/settings`

### Non-tab routes

- `/`
- `/welcome`
- `/exercise/:hour`
- `/workout/add-exercise`
- `/workout/custom-step`
- `/tips/:topicId`
- `/breathe/settings`

### Navigation rules to enforce

- Bottom tab changes use shell/tab navigation only.
- Subscreens are pushed on top of current context.
- Back on Home asks for quit confirmation.
- Back on any non-Home tab returns to Home.
- Back on detail screens pops to parent.
- Avoid duplicate screens in the stack.

---

## 8. Design Transfer Plan

The Flutter design system will be built by converting the React mockup into centralized Flutter tokens and reusable widgets.

### Visual source tokens from mockup

From `interactive_mockup/src/styles/theme.css`:

- Background: `#090f1e`
- Nav background: `#1d263b`
- Primary blue: `#25aaf9`
- Green CTA gradient: `#35b769 -> #1b9e52`
- Purple accent gradient: `#b57aff -> #8f33ea`
- Cyan breathing gradient: `#8FE4FF -> #1EBEF0`
- Red action gradient: `#ff4141 -> #ff6565`
- Gray text palette from the mockup

### Typography transfer

Fonts from mockup:

- `Open Sans` for body/UI text
- `Rubik` for selective labels such as bottom navigation

Flutter implementation:

- Use local variable fonts from `assets/fonts/`
- Define typography in `ui/theme/app_theme.dart`
- Register all static text via `constants/app_strings.dart`

Font asset plan:

- The user will add the variable font files into `assets/fonts/`
- Recommended files:
  - `OpenSans-VariableFont_wdth,wght.ttf`
  - `OpenSans-Italic-VariableFont_wdth,wght.ttf`
  - `Rubik-VariableFont_wght.ttf`
  - `Rubik-Italic-VariableFont_wght.ttf`

### Planned reusable widgets

- `AppShellScaffold`
- `AppBottomNavBar`
- `AppScreenHeader`
- `GradientCard`
- `AccentBar`
- `PrimaryPillButton`
- `OutlinePillButton`
- `DangerPillButton`
- `CircleIconButton`
- `SettingsToggleRow`
- `AppConfirmationDialog`
- `ProgressRing`
- `BreathingOrb`
- `EmptyStateCard`

### Screen-by-screen transfer approach

- Reproduce layout hierarchy from the React screens first.
- Replace inline style values with design tokens.
- Replace hardcoded content with provider-driven values.
- Preserve safe-area correctness and mobile-first spacing.

---

## 9. Feature Implementation Sequence

Implementation will be split into ordered phases to reduce rework.

### Phase 1. Foundation

Checklist:

- [x] Replace starter `main.dart`.
- [x] Add dependencies.
- [x] Wire debug-only `device_preview` foundation into the app startup plan.
- [x] Create app root, theme, route constants, shell scaffolding.
- [x] Add token files for spacing, sizes, radii, durations, colors, strings, images.
- [x] Finalize the base `assets/` folder structure.
- [x] Move initial images from the mockup into Flutter assets.
- [x] Register asset folders in `pubspec.yaml`.
- [x] Reserve font registration structure in `pubspec.yaml` for local variable fonts.

Exit criteria:

- App boots into a themed Flutter shell.
- Bottom navigation shell exists.
- Asset structure is in place and should not require later reorganization.
- No business data is hardcoded in UI widgets except placeholder strings during scaffolding.

### Phase 2. Models, storage, repositories

Checklist:

- [x] Add JSON models with `json_serializable`.
- [x] Add `PrefsStore`.
- [x] Add asset loader.
- [x] Add repositories for exercises, tips, quotes, workouts, progress, and settings.

Exit criteria:

- Bundled JSON can be loaded through repositories.
- Settings and progress can be persisted and restored.

### Phase 3. Providers and bootstrap

Checklist:

- [x] Add domain providers.
- [x] Add app bootstrap flow.
- [x] Add first-launch logic and splash routing.
- [ ] Add app lifecycle observer for permission re-checks.

Exit criteria:

- App starts with correct screen based on first launch.
- Providers initialize without writing fake progress.

### Phase 4. Core UI transfer

Checklist:

- [x] Implement Welcome, Home, Tips, Tip Detail, Quotes, Settings.
- [x] Implement shared components and exact visual language from mockup.

Exit criteria:

- Main browsing flow works end-to-end.
- Layout closely matches mockup.

### Phase 5. Interactive exercise flows

Checklist:

- [x] Implement Exercise screen timer and completion logic.
- [x] Implement Breathing screen animation/timer/settings.
- [x] Implement Workout, Add Exercise, and Custom Step flows with validation.

Exit criteria:

- Hourly exercise, breathing, and custom workout flows update progress correctly.

### Phase 6. Notifications and permissions

Checklist:

- [x] Integrate `flutter_local_notifications`.
- [x] Integrate `permission_handler`.
- [x] Implement rationale dialogs and scheduling logic.
- [x] Sync toggles with actual permission state.

Exit criteria:

- Reminder toggles behave correctly.
- Scheduling logic matches spec.

### Phase 7. Debug tooling and finish

Checklist:

- [ ] Complete persisted settings hookup for `device_preview` in debug-only mode per `docs/device_preview.md`.
- [ ] Final polish for back behavior, reset flows, text overflow, and edge cases.
- [ ] Run lint cleanup after the app is functionally complete.
- [ ] Verify assets, naming, and safe-area handling.

Exit criteria:

- Debug preview is toggleable and persisted in debug mode only.
- Spec-defined edge behaviors are covered.

---

## 9a. Execution Checklist

This section is the operational checklist we will update while implementing the app.

### Overall progress

- [x] Phase 1. Foundation
- [x] Phase 2. Models, storage, repositories
- [x] Phase 3. Providers and bootstrap
- [x] Phase 4. Core UI transfer
- [x] Phase 5. Interactive exercise flows
- [x] Phase 6. Notifications and permissions
- [ ] Phase 7. Debug tooling and finish

### Immediate next step

- [x] Start Phase 1 by replacing the starter Flutter counter app with the project foundation
- [x] Start Phase 2 by adding bundled data models, local asset loading, and repositories
- [x] Start Phase 3 by binding repositories into domain providers and replacing foundation placeholders with live startup state
- [x] Start Phase 4 by replacing tab placeholders with full mockup-driven UI for Welcome, Home, Tips, Tip Detail, Quotes, and Settings
- [x] Start Phase 5 by implementing the interactive exercise, breathing, and workout flows with timers, validation, and completion handling

---

## 10. Screen Implementation Notes

### Splash

- Timer-based auto-advance.
- Reads `is_first_launch`.
- No user interaction.

### Welcome

- Full-screen hero treatment from mockup.
- `Get Started` writes `is_first_launch = false`.

### Home

- Must use real derived progress values.
- Quick actions must route to actual flows.
- Quote of the day must come from `QuotesProvider`.

### Exercise

- Real countdown logic.
- Hour param is source of routine context.
- Completion modal updates progress and navigation.

### Workout flow

- Workout draft state must survive intra-flow navigation.
- Custom step validation follows technical spec exactly.

### Tips

- Topic list and detail content sourced from bundled JSON.

### Quotes

- Real quote rotation.
- “Past quotes” scope can be implemented after core behavior if needed, but route/button placeholder should not violate UI spec.

### Breathing

- Phase logic must support calm, energy, and focus patterns.
- Visual orb animation should reflect phase changes.

### Settings

- Toggle state must match persisted settings and notification permission state.
- Reset Progress requires confirmation and preserves onboarding/settings state.

---

## 11. Dependency Plan

Required packages for implementation:

- `provider`
- `shared_preferences`
- `go_router`
- `google_fonts`
- `flutter_local_notifications`
- `permission_handler`
- `audioplayers`
- `json_annotation`

Dev dependencies:

- `build_runner`
- `json_serializable`
- `device_preview`

Package additions must be reflected in `pubspec.yaml` before feature implementation starts.

---

## 12. Quality Gates

The implementation is considered acceptable only if all of the following are true:

- Provider structure is domain-scoped and not page-scoped.
- No direct persistence logic exists in pages/widgets.
- No direct asset paths are hardcoded in page widgets once constants are introduced.
- No inline “magic number” spacing/radius/duration values remain where tokens should exist.
- All user-visible static strings are centralized.
- All bundled/persisted models are typed and serializable.
- First launch starts empty.
- Reset behavior matches the spec exactly.
- Back behavior matches the spec exactly.
- Notification permission flow matches the spec exactly.
- Screen visuals follow the mockup closely while remaining Flutter-native.

---

## 13. Risks and Control Measures

### Risk: mockup and spec divergence

Control:

- Treat the React mockup as primary for design decisions.
- Resolve behavior and data rules from `technical_spec.md`.

### Risk: provider sprawl or page-scoped logic

Control:

- Keep provider responsibilities domain-based.
- Reuse providers across related screens.

### Risk: UI-first implementation leaking fake state

Control:

- Build repositories and providers before finalizing screen bindings.
- Disallow seeded progress data outside temporary scaffolding.

### Risk: navigation regressions

Control:

- Define route ownership and back rules before screen wiring.
- Test tab-switching and detail-flow return paths early.

### Risk: notification permission complexity

Control:

- Isolate permission and scheduling logic into services/providers.
- Re-check permission state on app resume.

---

## 14. Definition of Done

The app is done when:

- All screens in `technical_spec.md` are implemented.
- Visual styling matches the mockup’s design language.
- Local storage and bundled data behave per spec.
- Notifications and settings flows behave per spec.
- Provider architecture follows `guidelines_provider.md`.
- The app runs without demo-counter/starter-template remnants.
