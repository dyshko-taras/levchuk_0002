# Active Office — Functional Requirements

## Overview

A mobile Flutter app for office workers to stay active throughout the workday. Features hourly stretch routines, breathing exercises, custom workouts, wellness tips, and motivational quotes. No registration required — everything runs locally on-device. All exercise, tip, and quote data is bundled as local JSON assets.

---

## Data Models

```dart
class Exercise {
  String id;
  String name;          // e.g. "Stand Side Bend"
  String instruction;   // e.g. "Stand straight, place one hand on your hip..."
  String motivation;    // e.g. "Loosen up your spine and breathe deeply."
  int durationSeconds;  // e.g. 25
  String emoji;         // e.g. "📋"
}

class HourlyRoutine {
  int hour;             // 1–8
  String label;         // e.g. "1st Hour"
  String sublabel;      // e.g. "Midday Focus" (contextual label)
  Exercise exercise;
}

class CustomWorkout {
  String id;
  String name;
  List<WorkoutStep> steps;
  DateTime createdAt;
}

class WorkoutStep {
  String id;
  String name;          // exercise name or custom name
  int durationSeconds;
  bool isCustom;        // true if user-created step
}

class WellnessTopic {
  String id;
  String title;         // e.g. "Eye Health"
  String emoji;         // e.g. "🧠"
  String shortDescription;
  List<WellnessTip> tips;
}

class WellnessTip {
  String id;
  String title;         // e.g. "The 20-20-20 Rule"
  String body;          // full tip text
}

class Quote {
  String id;
  String text;
  String author;
  String toneTag;       // e.g. "Growth / Self-Discipline"
}

class UserProgress {
  Map<String, DayProgress> dailyProgress; // keyed by ISO date string
}

class DayProgress {
  Set<int> completedHours;    // which hours (1–8) completed
  int breathingMinutes;       // total breathing minutes today
  int workoutSessions;        // custom workout sessions completed
}

class UserSettings {
  bool hourlyReminders;       // default: true
  bool breathingReminders;    // default: true
  bool soundEnabled;          // default: false
}

class BreathingSettings {
  int durationMinutes;        // 1, 3, 5, or 10 — default: 3
  BreathingMode mode;         // Calm, Energy, Focus — default: Calm
  bool soundEnabled;          // default: true
}

enum BreathingMode { calm, energy, focus }
```

---

## Navigation / Routes

| Route | Screen | Notes |
|---|---|---|
| `/` | Splash Screen | Entry point, auto-advances |
| `/welcome` | Welcome Screen | First launch only |
| `/home` | Home Screen | Main tab screen |
| `/exercise/:hour` | Exercise Screen (Hourly) | Pushed from Home hourly list |
| `/workout` | Custom Workout Screen | Main tab screen |
| `/workout/add-exercise` | Add Exercise Screen | Pushed from Custom Workout |
| `/workout/custom-step` | Custom Step Screen | Pushed from Add Exercise |
| `/tips` | Wellness Tips List | Main tab screen |
| `/tips/:topicId` | Tip Detail Screen | Pushed from Tips list |
| `/quotes` | Motivational Quotes | Main tab screen |
| `/breathe` | Focus Breathing Screen | Main tab screen |
| `/breathe/settings` | Breathing Settings Panel | Pushed from Breathing screen |
| `/settings` | Settings Screen | Main tab screen |

**Navigation pattern:** `go_router` with `ShellRoute` for the 6 bottom tab items (Home, Tips, Breathe, Quotes, Workout, Settings). Sub-screens are pushed on top of the stack.

**Navigation rules (per audit guide):**
- `push()` — forward navigation where Back should return to the current screen
- `pop()` — returning to a screen already on the stack (e.g. after editing)
- `pushReplacement()` — when the current screen is a transient step the user should NOT return to
- `go()` — only for top-level tab switches (bottom nav) or full flow resets (splash → home)
- Never push a screen that's already below on the stack — use `pop()` or `pushReplacement()` instead

**System back button behavior:**
- On Home screen: show app quit confirmation dialog (styled to match app theme)
- On any other main tab screen (Tips, Breathe, Quotes, Workout, Settings): navigate to Home
- On sub-screens (Exercise, Tip Detail, Custom Step, etc.): pop back to parent

---

## Bottom Navigation Bar (Tab Bar)

Present on all 6 main tab screens. Dark background (`#1d263b`).

| Index | Emoji | Label | Route |
|---|---|---|---|
| 0 | 🏠 | Home | `/home` |
| 1 | 💡 | Tips | `/tips` |
| 2 | 🌬 | Breathe | `/breathe` |
| 3 | 🏆 | Quotes | `/quotes` |
| 4 | 🧘 | Workout | `/workout` |
| 5 | ⚙️ | Settings | `/settings` |

Active item: blue gradient indicator bar above the item (`#53adff` → `#135ac2`). All items show emoji icon + label in white.

---

## Screens

---

### Screen 1 — Splash Screen

**Route:** `/`

**Layout:** Dark background (`#090f1e`), centered vertically.
- Text "Loading..." (large, white, bold)
- Segmented loading bar below (16 segments: active segments in Primary Blue `#25aaf9`, inactive in `rgba(255,255,255,0.15)`)

**Logic:** Auto-advance after 2–3 seconds. Read `is_first_launch` flag:
- `true` → Welcome Screen
- `false` → Home Screen

No buttons or user input.

---

### Screen 2 — Welcome Screen

**Route:** `/welcome`
**No bottom nav.**

**Layout:**
- Headline: "Discover ActiveOffice: Your Partner for Active Office Hours" (Primary Blue `#25aaf9` for "Discover ActiveOffice:", White for rest)
- Subhead: "Hourly stretches, wellness tips, and inspiration — all in one place" (gray text)
- Background illustration of a woman at an office desk (decorative)
- Button (green, pill): "Get Started" → sets `is_first_launch = false` → navigates to Home

---

### Screen 3 — Home Screen

**Route:** `/home`
**Bottom nav active:** Home

**Purpose:** Central dashboard with progress summary, hourly routine list, quick actions, and quote of the day.

**Layout (scrollable):**

**Header:**
- Title: "ActiveOffice Daily Routine" (Primary Blue, bold) + gear icon (⚙️) top-right → navigates to Settings
- Subtitle: "Stay balanced throughout your workday" (gray)
- Blue accent bar below header

**Block: Today's Progress** (gradient card with blue accent bar at top)
- Row: "✅ Completed Hours:" + right-aligned value "3 / 8" (green)
- Row: "🏃 Breathing:" + right-aligned value "9 min" (green)
- Row: "🔥 Streak:" + right-aligned value "5 days" (green)
- Link: "🔄 Reset Day" (blue text, right-aligned) → confirmation dialog → resets today's progress

**Block: Hourly Routine** (🕐 section heading)
- 8 list item rows (one per hour), each showing:
  - Left: "1st Hour", "2nd Hour", ... "8th Hour"
  - Right: exercise name + status emoji (✅ completed, 🕐 in progress, ⏳ pending) + chevron ►
- Tap any row → Exercise Screen for that hour

**Block: Quick Actions** (✨ section heading)
- 3 action cards in horizontal row (purple gradient background):
  - "🏃 Quick Stretch" → launches Exercise Screen for current hour with auto-start
  - "🌬 Open Breathe" → navigates to Focus Breathing
  - "💡 Tips of the Day" → navigates to a random Tip Detail

**Block: Quote of the Day** (gradient card with purple accent bar)
- "✨ Quote of the Day:"
- Quote text (white)
- Author attribution (purple, italic, right-aligned)

**Data & calculations:**
- Completed Hours: count of hours in `completedHours` set for today
- Breathing: sum of `breathingMinutes` for today
- Streak: consecutive days where `completedHours.isNotEmpty || breathingMinutes > 0`
- Hourly routine exercises loaded from `hourly_exercises.json`

**Empty state:** "No activity yet. Start with 'Quick Stretch' or 'Open Breathe'."

---

### Screen 4 — Exercise Screen (Hourly Routine)

**Route:** `/exercise/:hour`
**Back button** → returns to Home

**Layout:**

**Header:**
- "◄ Back" (top-left)
- Title: "Stay Active at Work" (Primary Blue, bold)
- Chat/info icon (💬) top-right
- Subtitle: "Hourly stretches to refresh your body and boost focus" (gray)
- Blue accent bar

**Exercise Card** (gradient card):
- Exercise emoji + name (bold, white, e.g. "📋 Stand Side Bend")
- "🫧 Motivation:" + motivational text (gray)
- Instruction text in lighter card (gray text)

**Timer Block:**
- Large circular progress ring (purple gradient: `#b57aff` → `#8f33ea`)
- Center: large timer "00:25" (white, very large)
- Status message below timer (changes dynamically):
  - Start: "Let's go!"
  - 50%: "Halfway there!"
  - Last 5s: "Almost done..."
  - Finish: "Great job!"

**Controls (bottom row):**
- ⏮ Previous (circular dark button) — go to previous exercise
- ▶ Start / ⏸ Pause / Stop (red pill button) — start/pause/stop timer
- ⏭ Next (circular dark button) — skip to next exercise

**Hour Info Card** (bottom, gradient card with purple accent bar):
- "🕐 Hour:" + hour label (e.g. "3rd Hour — Midday Focus")
- "📈 Streak continues!" (green, when applicable)

**Completion Popup** (modal, white background):
- "🎉 Session Complete"
- "You've completed your hourly exercise! Time for a short water break."
- Two buttons side by side:
  - "Stop" (red pill) → marks hour complete, returns to Home
  - "Start" (green pill) → repeats exercise

**Logic:**
- Timer counts down from exercise `durationSeconds`
- Previous/Next cycle through exercises assigned to this hour
- On completion: mark hour as completed in `user_progress`, update streak
- "Done for this hour" enabled only after completing at least one exercise set

---

### Screen 5 — Custom Workout Screen

**Route:** `/workout`
**Bottom nav active:** Workout

**Layout:**

**Header:**
- "◄ Back" + Title: "Create Workout" (Primary Blue)
- Gear icon (⚙️) top-right
- Subtitle: "Build your personalized desk routine" (gray)
- Blue accent bar

**Current Routine Card** (gradient card):
- "📋 Current Routine:" heading
- Numbered list of exercises, each row:
  - Number (green, bold) + exercise name + duration (green, right-aligned, e.g. "00:25")
  - Example: "01 Stand Side Be... 00:25"

**Add Exercise Button** (dashed border, dark):
- "+ Add Exercise" → navigates to Add Exercise Screen

**Bottom buttons:**
- "💾 Save Routine" (green outlined pill) → prompts for name → saves to `custom_workouts.json`
- "▶ Start Routine" (green filled pill) → starts the routine runner (same template as hourly exercise, but uses the custom step list)

**Logic:**
- Adding exercises pushes them to the current draft list
- Save Routine persists to local storage
- Start Routine opens the exercise runner with the draft/saved steps
- On routine completion: `workout_sessions += 1` in `user_progress`

---

### Screen 5a — Add Exercise Screen

**Route:** `/workout/add-exercise`
**Back button** → returns to Custom Workout

**Layout:**
- Title: "Add Exercise" (Primary Blue)
- Search input: "🔍 Search exercises..." (dark input field)
- List of available exercises, each row:
  - Checkbox (green circle: ✅ selected / ○ unselected) + emoji + exercise name + duration (green)
- Bottom button: "+ Custom Step" (green filled pill) → navigates to Custom Step Screen

**Logic:**
- Exercises sourced from the same `hourly_exercises.json` pool
- Toggling checkbox selects/deselects exercise for the routine
- Selected exercises added to the current workout draft on back navigation
- Search filters the list by name

---

### Screen 5b — Custom Step Screen

**Route:** `/workout/custom-step`
**Back button** → returns to Add Exercise

**Layout:**
- Title: "Custom Step" (Primary Blue)
- Input: "Name:" label + text field (dark, placeholder: exercise name) — **required**
- Input: "Duration:" label + time field (dark, format "00:25") — **required**, min 5 seconds, max 300 seconds (5 min)
- Bottom buttons:
  - "Back" (dark disabled-style pill) → returns without saving
  - "✅ Add to Routine" (green filled pill) → validates and adds custom step to draft, returns

**Form validation (per audit guide):**
- "Add to Routine" button is always tappable (never silently disabled)
- On tap with empty/invalid fields: highlight invalid fields with red error border + inline error message below (e.g. "Name is required", "Duration must be between 0:05 and 5:00")
- Errors appear only after first submit attempt; clear automatically as user fills in valid values
- Duration field: numeric keyboard, accepts only digits and colon, clamped to 5–300 seconds range
- Name field: `maxLines: 1`, `overflow: TextOverflow.ellipsis` for display in routine list

---

### Screen 6 — Wellness Tips (List)

**Route:** `/tips`
**Bottom nav active:** Tips

**Layout:**
- "◄ Back" + Title: "Wellness Tips" (Primary Blue) + gear icon
- Scrollable list of topic cards, each:
  - Emoji + topic title (white, bold)
  - Short description (gray)
  - Blue accent bar at top of each card
  - Cards separated by spacing

**Topics (10 total):**
1. 🧠 Eye Tips — "Reduce strain and protect your eyes during long hours in front of a screen"
2. 🏋 Posture Tips — "Keep your body aligned and comfortable throughout the workday"
3. 😌 Stress Tips — "Calm your mind, manage daily pressure, and improve focus"
4. ⚡ Focus & Fatigue — "Reignite concentration and maintain steady energy throughout the day"
5. 🧃 Hydration & Nutrition — "Fuel your body with hydration and simple, energizing meals"
6. 🌙 Sleep & Recovery — "Rest deeply to recharge your mind and body"
7. 🎭 Mental Health — "Build emotional balance and resilience against daily stress"
8. 🧍 Mobility & Stretching — "Stay flexible and prevent stiffness caused by prolonged sitting"
9. 💻 Productivity & Time Balance — "Work smarter, not longer — balance focus and rest"
10. 🌬 Breathing & Relaxation — "Regain calm and focus through intentional breathing"

**Action:** Tap card → Tip Detail Screen

---

### Screen 7 — Tip Detail Screen

**Route:** `/tips/:topicId`
**Back button** → returns to Tips List

**Layout:**
- Header: topic emoji + topic title (e.g. "🧠 Eye Tips")
- List of tips, each as a card:
  - Tip title (bold, white)
  - Tip body text (gray)
- Button: "Back" at bottom

**Data:** Each topic has 3 tips loaded from `tips.json`. Does not write to progress.

---

### Screen 8 — Motivational Quotes

**Route:** `/quotes`
**Bottom nav active:** Quotes

**Layout:**
- "◄ Back" + Title: "Inspiring Quotes" (Primary Blue) + gear icon
- Purple accent bar
- Quote card (gradient card with purple accent bar):
  - "✨ Quote of the Day:"
  - Quote text (white)
  - "— Author" (purple, italic, right-aligned)

**Bottom buttons:**
- "Past quotes" (green outlined pill) → shows list/history of previously shown quotes
- "Next Quote" (green filled pill) → loads random next quote

**Data:** 30 quotes loaded from `quotes.json`. Does not save progress (optionally track view count locally for analytics).

---

### Screen 9 — Focus Breathing

**Route:** `/breathe`
**Bottom nav active:** Breathe

**Layout:**

**Header:**
- "◄ Back" + Title: "Focus Breathing" (Primary Blue)
- Subtitle: "Relax your mind. Refocus your energy" (gray)

**Timer:**
- Large countdown timer "02:32" (white, very large)
- "Cycle 2 of 5" below (gray)

**Breathing Animation:**
- Concentric circles (cyan gradient: `#8FE4FF` → `#1EBEF0`)
- Center circle expands/contracts with breathing phase
- Phase caption inside circle (changes dynamically):
  - "Inhale..."
  - "Hold..."
  - "Exhale..."
  - "Hold..."

**Controls (bottom row):**
- ⚙️ Settings (circular dark button) → navigates to Breathing Settings Panel
- "Stop" (red pill button) → stops session, returns to idle state
- 🔄 Restart (circular dark button) → restarts current session

**Breathing Modes (phase durations in seconds: inhale-hold-exhale-hold):**
- Calm: 4–4–6–2
- Energy: 3–1–3–1
- Focus: 3–2–4–2

**Completion Popup** (modal, white background):
- "🎉 Well done!"
- "You've completed your breathing session"
- "🏠 Back to Home" (green pill button) → navigates to Home

**Logic:**
- Start → runs cycles according to active Mode and Duration
- Number of cycles calculated from duration and phase lengths
- On completion: `breathing_minutes += duration` in `user_progress`, update streak
- Circle animation size represents current phase (small = inhale start, large = hold after inhale)

---

### Screen 9a — Breathing Settings Panel

**Route:** `/breathe/settings`
**Back button** → returns to Focus Breathing

**Layout:**
- Title: "Settings Panel" (Primary Blue)
- "Duration, (min):" label
  - 4 option buttons in row: 1 | 3 | 5 | 10
  - Selected: green background, white text
  - Unselected: dark surface, gray text
- "Mode:" label
  - 3 option buttons in row: Calm | Energy | Focus
  - Same selected/unselected styling
- Sound toggle row: "Sound:" + toggle switch (green when on)

---

### Screen 10 — Settings

**Route:** `/settings`
**Bottom nav active:** Settings

**Layout:**

**Header:**
- "◄ Back" + Title: "Settings" (Primary Blue)

**Toggle rows** (dark card, each row):
- "Hourly Reminders" + toggle (default: ON) — hourly stretch notifications
- "Breathing Reminders" + toggle (default: ON) — every-2-hours breathing notifications
- "Sound" + toggle (default: OFF)

**Notification permission flow (triggered when user enables Hourly or Breathing Reminders):**
1. Show rationale dialog first: "ActiveOffice needs notification permission to send you stretch and breathing reminders during your workday." with "Allow" / "Not now" buttons.
2. If user taps "Allow" → show system permission request.
3. If user previously permanently denied the system request (and system dialog can no longer be triggered), show a rationale dialog with "Open Settings" button that navigates to system app settings.
4. If permission is denied, show inline warning below the toggle: "Notifications are disabled. Enable them in system settings to receive reminders."
5. Re-check permission status on app resume (user may have changed it in system settings while app was backgrounded).
6. Sync toggle state with actual system permission — if user revokes permission externally, reflect OFF state in the toggle.

**About section:**
- "About" heading (white, bold)
- "Version: 1.0.0"
- "Build: 2025.10.15"
- "Brand Integration: ActiveOffice"

**Action buttons (stacked, green outlined pills):**
- "Share App" → native share sheet
- "Rate App" → opens store listing
- "Privacy Policy" → opens privacy policy URL

**Danger button (red filled pill):**
- "Reset Progress" → confirmation dialog ("Type RESET") → clears **user-generated data only** (`user_progress` daily records, custom workouts) — preserves `is_first_launch` flag, settings, and other app-internal state so user is not forced through onboarding again

**Logic:**
- All settings changes immediately persisted to `user_settings` (SharedPreferences)
- Enabling Hourly Reminders → triggers notification permission flow (see above) → schedules local notifications every hour (9:00–18:00)
- Enabling Breathing Reminders → triggers notification permission flow → schedules notifications every 2 hours
- Sound toggle affects exercise timer and breathing sounds

---

### Screen 11 — Hourly Reminder Engine (System Behavior)

Not a screen — background system behavior.

- If `hourlyReminders = true`: schedule local notification every hour during work interval (9:00–18:00 default)
  - Notification text: "It's time to stretch!"
  - Tap notification → opens Exercise Screen for current hour (no auto-start)
- If `breathingReminders = true`: schedule every 2 hours
  - Notification text: "Take a 3-minute breathing break."
  - Tap notification → opens Focus Breathing with preset mode: Focus, duration: 3 min

---

## Bundled Data Assets

| File | Contents |
|---|---|
| `hourly_exercises.json` | 18 exercises (Stand Side Bend, Chair Squat, Neck Stretch, Shoulder Rolls, Hand Stretch, Knee Raise Right, Back Twist, Calf Raise, Seated Leg Extension, Upper Back Stretch, Ankle Circles, Torso Side Twist, Seated Marching, Wrist Rotations, Forward Fold, Arm Circles, Shoulder Shrugs, Glute Squeeze) — each with name, instruction, motivation, duration |
| `tips.json` | 10 wellness topics, each with 3 detailed tips |
| `quotes.json` | 30 motivational quotes with author and tone tag |

---

## Local Storage

| Store | Technology | Contents |
|---|---|---|
| User progress | SharedPreferences or SQLite | `UserProgress` — daily completed hours, breathing minutes, workout sessions |
| User settings | SharedPreferences | Toggles: hourly reminders, breathing reminders, sound |
| Breathing settings | SharedPreferences | Duration, mode, sound |
| Custom workouts | SharedPreferences (JSON) or SQLite | `CustomWorkout` records |
| First launch flag | SharedPreferences | `is_first_launch` boolean |

---

## Data Persistence Rules

- The app must start with **empty user data** on first launch. Never seed mock/sample data into production state.
- All progress, settings, and custom workout changes must be persisted immediately — do not batch or defer writes.
- `is_first_launch` flag and app settings survive "Reset Progress" — only user-generated content is cleared.

---

## Audit Rules Reference

Implementation must comply with the audit rules in `docs/audit_rules/`:

- **[ux_guide.md](audit_rules/ux_guide.md)** — permissions rationale flow, text overflow handling (ellipsis on user-generated strings), safe area handling, back/close button consistency, go_router navigation stack rules, form validation, numeric input limits
- **[behavior_guide.md](audit_rules/behavior_guide.md)** — data persistence (empty on first launch, immediate writes), app lifecycle (re-check permissions on resume), error recovery, performance guardrails (ListView.builder for lists), security
- **[asset_guide.md](audit_rules/asset_guide.md)** — WebP for raster images, variable fonts preferred, snake_case naming, image size limits (500 KB max), font registration in pubspec.yaml

---

## Flutter Package Dependencies

| Package | Purpose |
|---|---|
| `shared_preferences` | Key-value local storage |
| `flutter_local_notifications` | Hourly & breathing reminder notifications |
| `provider` or `riverpod` | App state management |
| `google_fonts` | Open Sans + Rubik fonts |
| `audioplayers` | Timer sounds and breathing metronome |
| `go_router` | Declarative routing with ShellRoute for tab navigation |
| `permission_handler` | Notification permission requests and status checks |
