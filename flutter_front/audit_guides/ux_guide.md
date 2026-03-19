# UX rules the app should follow
## Permissions requests (gps, notifications, camera etc.).

1. Ask for a permission when the app really needs it. E.g. app scans the map for the shops, or user sets a reminder or toggles reminders togge.
2. Show a rationale before showing a system request.
3. If user permanently denied system request, allow to open system settings in the rationale dialog to set the permission there.
4. Ensure to show permission blocked warning only if the user already permanently denies it in system requests and the system requests cannot be triggered anymore.
5. Re-check permissions on user's return into the app.
6. Sync permission toggle with system settings.
7. Inform user in the UI about the lacking permission if you can't display the data the permission is required for.

## Long text and overflow handling

All user-generated strings (names, titles, labels entered by the user or fetched from external sources) must be protected against overflow in every widget where they appear.

1. Never place an unconstrained `Text` widget displaying user-generated content inside a `Row` without either wrapping it in `Flexible`/`Expanded` or setting `maxLines` + `overflow`.
2. Any `Text` that shows a user-generated string in a single-line context must have `maxLines: 1` and `overflow: TextOverflow.ellipsis`.
3. In layouts with `mainAxisAlignment: spaceBetween` (e.g. scoreboard-style rows with a label on each side and a value in the middle), wrap each label side in `Flexible` and the inner text column in another `Flexible`, so the fixed-width center element is never pushed out.
4. Apply ellipsis in modal/bottom-sheet titles and list-item headings that display user content — modals are not scroll-protected.
5. When adding a new widget that renders a string from state, user input, or a remote source, always ask: "What happens if this string is 100 characters long?" before shipping.

## Safe area handling

All screens must respect the top safe area (notch, camera cutout, status bar region) so that headers and content never overlap system UI elements.

1. Apply `SafeArea` in **one place per navigation layer**. If the app uses a shell route (e.g. `ShellRoute` with bottom nav), wrap the child in `SafeArea` inside the shell layout. Individual screens inside that shell must NOT add their own `SafeArea` — that causes double padding.
2. Standalone screens (outside the shell — creation flows, full-screen modals, onboarding) must apply `SafeArea` individually since the shell doesn't wrap them.
3. Set `bottom: false` on `SafeArea` when the app uses immersive/edge-to-edge mode with the system navigation bar hidden. If the app does not use immersive mode, respect the bottom safe area too.
4. Never double-wrap with `SafeArea`. Before adding one, check whether a parent widget already provides it.

## Screen header — back/close button consistency

### Leading icon rules

| Screen Type | Leading Icon |
|---|---|
| **Top-level destination** (tab root, home screen) | None |
| **Sub-screen within hierarchy** (detail view, drill-down from a list, sub-page reached via push) | ← back arrow (`Icons.arrow_back`) |
| **Standalone flow / modal overlay** (creation, editing, settings — entered from outside normal hierarchy) | X close (`Icons.close`) |

1. **Back arrow (←)** means "return to the previous screen in the hierarchy." Use for detail views, sub-pages, and any screen the user reached by tapping an item.
2. **X close** means "dismiss / cancel this flow." Use for creation forms, editing flows, settings screens, and any task the user can abandon without a parent-child relationship to return to.
3. Never use X close on a detail view reached by tapping a list item — users expect to go *back*, not *dismiss*.
4. Never use back arrow on a standalone creation/editing flow — users expect to *cancel/dismiss*, not navigate back in a hierarchy.

### Placement

5. The back arrow or X close button must always be the **leftmost element** in the screen header. Never place it on the right side — Android users expect navigation actions on the left per Material Design conventions.
6. If the header has a custom layout (not using `AppBar` or a standard header widget), verify the leading icon comes first in the `Row` children, before the title.

## Image dimensions
Check dimensions of all image assets so you would use correctly sized containers inside app's widgets.

## Navigation

Flutter Navigation Stack Rules (go_router)

When implementing navigation with go_router, follow these rules to prevent stack pollution:

push() — Only for forward navigation where the user should be able to press Back to return to the current screen. The current screen remains meaningful to return to.

pop() — When returning to a screen that's already on the stack (e.g., after editing, the previous screen refreshes via state invalidation). Prefer pop() over pushing a duplicate route.

pushReplacement() — When the current screen is a transient step the user should NOT return to. Examples: form picker → builder (picker is done), builder → overview after creating (builder is done).

go() — Only for top-level tab switches (bottom nav) or full flow resets (splash → home). Never use mid-flow as it destroys the entire stack.

Never push a screen that's already below you on the stack. If Overview → Builder → save, don't push(Overview) again. Either pop() back to the existing Overview, or pushReplacement().

After any mutating action (save/delete/create), invalidate Riverpod providers that other screens on the stack depend on, so they show fresh data when the user returns via pop().

Mental model: trace the Back button. For every push() call, ask: "If the user presses Back from the destination, does landing on the current screen make sense?" If not, use pushReplacement() instead.

If user navigates presses system back button on a home screen, show app quit confirmation dialog. Follow app's visual style. In case of another main screen (available from the navbar), system back button should open home screen.

## Required field validation

1. Every form with obligatory fields must validate on submit, not silently disable the submit button. The submit action should always be tappable so the user receives clear feedback about what is missing.
2. When the user taps submit with incomplete fields, highlight every empty required field with a visible error border (e.g. red/primary-error color, 1–2 px) and display a short error message directly below the field explaining what is expected.
3. Error indicators must appear immediately on submit attempt and clear automatically as soon as the user fills in the corresponding field.
4. Do not show errors before the first submit attempt — avoid punishing the user while they are still filling out the form.
5. Track a "submitted" flag in the form state. Per-field error getters should return messages only when this flag is true and the field is invalid.
6. Use the app's existing error/danger color for borders and error text to maintain visual consistency.
7. For non-text required fields (dropdowns, selectors, date/time pickers), apply the same error border and message pattern as text inputs.

## Numeric input fields — realistic limits

Every numeric input field must enforce realistic value ranges. Unrealistic values (e.g. a person weighing 70 000 kg, a price of $999 999 999, a quantity of 10 billion) can break calculations, overflow UI layouts, hang charts, or corrupt stored data.

### Defence in depth — three layers

#### 1. UI layer (TextField)
- Use `FilteringTextInputFormatter` to allow only valid characters (digits, optional decimal point, optional minus sign if negatives are meaningful).
- Use `LengthLimitingTextInputFormatter` to cap the number of characters a user can type.
- Set the appropriate `keyboardType` (`TextInputType.number`, `TextInputType.numberWithOptions(decimal: true)`, etc.).

#### 2. Controller / setter layer
- Every setter that accepts a numeric value from a text field must clamp it to the domain-appropriate range before storing it in state.
- This catches values that bypass the UI (programmatic calls, data migration, state restoration).

#### 3. Calculation / save layer
- Functions that compute derived values (totals, goals, scores) must clamp both their **inputs** and **outputs** independently, so stale or corrupt data never produces absurd results.

### How to choose limits

For every numeric field, ask: *"What is the smallest and largest value that makes sense in the real world for this field?"* Set limits accordingly.

**Domain examples** (illustrative — adapt to each app's context):

| Domain | Field | Realistic min | Realistic max | Why |
|--------|-------|--------------|---------------|-----|
| Health / fitness | Human weight (kg) | 20 | 400 | Covers children to extreme recorded weights |
| Health / fitness | Human height (cm) | 50 | 280 | Tallest person ever: 272 cm |
| Health / fitness | Age (years) | 1 | 150 | |
| Health / fitness | Calories per meal | 1 | 9 999 | No single meal exceeds ~10 000 kcal |
| Health / fitness | Water intake per entry (ml) | 1 | 5 000 | ~1.3 gal — realistic single drinking |
| Health / fitness | Exercise duration (min) | 0 | 1 440 | 24 hours in a day |
| E-commerce | Price ($) | 0 | 999 999 | Depends on product category |
| E-commerce | Quantity | 1 | 9 999 | Bulk orders rarely exceed this |
| Finance | Transfer amount | 0.01 | 1 000 000 | Depends on account tier |
| Social / text | Character count | 0 | 5 000 | Platform-specific |
| Time / scheduling | Duration (hours) | 0 | 744 | Max hours in a month |

For **computed / derived values** (e.g. daily calorie goal, total price, account balance), also define output clamps so that even if inputs were at their maximum, the output stays within a displayable and meaningful range.

### Rules

1. **Domain-aware ranges over character-length limits.** A 3-digit character limit allows "999" but also "0" — it does not encode that human height starts at 50 cm. Always pair character limits with a meaningful min/max clamp.
2. **Clamp in setters, not just UI.** Use `.clamp(min, max)` in Dart setters and calculation functions — data can arrive from storage, migration, API responses, or programmatic calls that bypass the UI entirely.
3. **Silence computed-value clamps.** If a calculated output (goal, total, score) exceeds its clamp, cap it silently — do not show error UI for values the user did not type.
4. **Centralise limit constants.** Define min/max constants in one place (e.g. a calculator or constants class) so UI formatters, setters, and calculators all reference the same source of truth. Avoid scattering magic numbers across widgets.
5. **Think about downstream effects.** Before shipping any numeric field, trace what happens when the maximum value flows through every calculation, chart, and display widget that consumes it. If it overflows a layout, hangs a chart, or produces a nonsensical derived value — tighten the limit or add output clamping.
6. **Validate on submit, never silently clamp user input.** Character-length and input formatters reduce typos, but they cannot prevent every unrealistic value (e.g. 999 kg weight). When the user taps Save/Submit, validate every numeric field against its domain range and show a visible error message with the acceptable range (e.g. "20–400 kg") directly on the field. Do not silently clamp user-entered values to a valid range — the user must see that their input was rejected and understand why. Follow the same `_submitted` flag + error getter pattern described in the "Required field validation" section. Setter-level clamping is still needed as a safety net for programmatic sources, but user-facing forms must give explicit feedback.

## Settings / Profile screen — required and prohibited items

### Required buttons

The app must include the following buttons in Settings, Profile, or another appropriate screen:

1. **Privacy Policy** — opens the app's privacy policy. The button must be present; the handler may be a placeholder (it is wired by a separate plugin).
2. **Support** or **Contact Us** — opens a support/contact channel. The button must be present; the handler may be a placeholder (it is wired by a separate plugin).
3. **Generate sample data** — see [behavior_guide.md](behavior_guide.md), "Sample data generation" section.
4. **Delete user data** — see [behavior_guide.md](behavior_guide.md), "Delete user data" section.

### Prohibited buttons

Do not include the following buttons — they are unnecessary and add clutter:

1. **Rate Us** / **Rate the App** — do not add.
2. **Share App** / **Tell a Friend** — do not add.

## Offline/connectivity and map behavior
See [behavior_guide.md](behavior_guide.md) — sections "Connectivity and offline handling" and "Map tiles".