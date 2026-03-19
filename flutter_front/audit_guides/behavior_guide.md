# App behavior rules

Runtime behavior rules for Flutter apps. Use this document to audit an app after implementation — verify each section against the codebase.

## Connectivity and offline handling

Use a real connectivity checker (e.g. `internet_connection_checker_plus`) that performs actual HTTP lookups — not just WiFi/mobile data availability checks.

1. Expose connectivity status as a reactive stream/provider so all UI components can watch it and rebuild automatically.
2. When no internet connection is detected, show a persistent warning banner (e.g. amber/yellow with a `wifi_off` icon) on every screen that depends on network data. The banner must appear automatically when connection is lost and disappear when restored. It must not block user interaction.
3. If a user action would open or reveal a network-dependent widget (e.g. tapping "show on map"), check connectivity first and show a snackbar/toast warning if offline. Still allow the action — don't block it.
4. On offline-to-online transition, clear Flutter's image cache (`PaintingBinding.instance.imageCache.clear()` and `.clearLiveImages()`) to purge cached error/empty images.
5. Force network-dependent widgets to rebuild on reconnect. Use a generation counter that increments on every offline-to-online transition and apply it as a `ValueKey` on widgets that fetch remote data. When the key changes, recreate any associated controllers since the old widget (and its bindings) will be disposed.

## Map tiles

### Offline resilience

1. Set `evictErrorTileStrategy: EvictErrorTileStrategy.dispose` (or equivalent) on every `TileLayer` so that error tiles are not persisted in cache.
2. Apply the connectivity generation counter as a `ValueKey` on map widgets to force fresh tile requests on reconnect.
3. Suppress tile-provider network exceptions (e.g. `SocketException`, DNS lookup failures) from error logging — they are expected when offline. Add a targeted error filter (e.g. `FlutterError.onError` override) that suppresses tile-provider image loading errors specifically, while preserving all other error reporting.
4. Apply offline handling to ALL map instances in the codebase: main map views, mini-maps, map pickers, inline previews.

### Tile caching

Map tiles must be cached locally so they are not re-downloaded on every map view open or scroll.

1. Use a persistent tile cache (e.g. `flutter_map_cache` with `HiveCacheStore` or `FileCacheStore`). Do not rely solely on Flutter's in-memory `ImageCache` — it is cleared on app restart and has a limited size.
2. Store the tile cache in the app's documents or cache directory (via `path_provider`). Use a dedicated subdirectory (e.g. `map_tiles/`) to isolate tile data from other app storage.
3. Initialize the cache store asynchronously. While the store is loading, fall back to the default `NetworkTileProvider` so the map is usable immediately.
4. On offline-to-online transition, do NOT clear the tile cache — only clear Flutter's in-memory image cache. The persistent tile cache contains valid data that should be preserved.
5. Consider cache size. If the app targets areas with dense map usage, monitor disk usage and set a max cache size or TTL eviction policy if the cache library supports it.

## Data persistence

1. The app must start with empty user data on first launch. Never seed mock/sample data into production state.
2. Persisted state (favorites, saved items, preferences) must survive app restarts. Verify by force-stopping the app and relaunching.
3. After any mutating action (save, delete, create), persist changes immediately — do not batch or defer writes that could be lost on crash.

### Sample data generation

The app must provide a button to generate sample data. This serves as a quick demo for users exploring the app for the first time.

1. Place the button in Settings, Profile, or another appropriate screen.
2. The button label must fit the app's domain — e.g. "Generate Sample Data", "Create Example Projects", "Generate Demo Tasks". Do not use generic labels like "Generate Test Data" or "Fill Mock Data".
3. The button must work in **both debug and release** builds. It is a user-facing feature, not a developer tool.
4. On tap, show a **confirmation dialog** warning the user that existing data will be replaced.
5. When confirmed, **delete all user data first**, then fill in the generated sample data. This ensures a clean, predictable demo state regardless of what the user had before.
6. Generated sample data must cover **all user data types** the app supports (e.g. if the app has projects, tasks, favorites, and notes — generate all of them, not just one type).
7. Sample data must be realistic and fit the app's domain — realistic names, plausible dates, varied content. Do not use placeholder text like "Test item 1", "Lorem ipsum", or obviously fake data.
8. Once generated, sample data is treated as normal user data — it can be edited, deleted, and is subject to all the same persistence rules.

### Delete user data

The app must provide a button to delete all user data.

1. Place the button in Settings, Profile, or another appropriate screen. Label it "Delete User Data", "Delete Data", "Clear Data", or similar.
2. On tap, show a **confirmation dialog** warning that all user data will be permanently deleted.
3. When confirmed, delete **user-generated data only**: favorites, saved items, lists, logs, entries, and any content created by the user.
4. **Preserve service data**: onboarding-completed flag, app launch count, internal feature flags, analytics identifiers, theme preferences, and other non-content state. The user must not be forced through onboarding again or lose app configuration.

## App lifecycle

1. Re-check permissions on app resume (`didChangeAppLifecycleState` → `resumed`). The user may have changed them in system settings while the app was backgrounded.
2. Re-check connectivity on app resume. If the app was offline and is now online (or vice versa), update UI accordingly.
3. If the app displays time-sensitive data (events, countdowns, "today" labels), refresh it on resume — the user may return after hours or days.

## Error recovery

1. Network requests that fail due to transient errors (timeout, 5xx) should offer a retry action in the UI — do not silently fail or show a dead-end error.
2. Never retry automatically in a tight loop. If implementing automatic retry, use exponential backoff with a cap (e.g. 3 attempts).
3. If a background operation fails (e.g. saving data), surface the failure to the user. Silent data loss is worse than an error message.

## Performance guardrails

1. Use `ListView.builder` (or `SliverList` with delegates) for any list backed by dynamic data. Never use `ListView(children: [...])` with more than ~20 items.
2. Network images must use a caching library (e.g. `cached_network_image`). Do not load images directly via `Image.network` — it re-downloads on every rebuild.
3. Debounce search/filter inputs that trigger network requests or expensive rebuilds. A 300–500 ms debounce is typical.
4. Avoid synchronous heavy work on the main isolate. JSON parsing, image processing, or large data transformations should use `compute()` or isolates if they risk dropping frames.

## Security

1. Never store sensitive data (tokens, passwords, API keys) in plain `SharedPreferences` or unencrypted Hive boxes. Use `flutter_secure_storage` or encrypted Hive.
2. Never log sensitive data (tokens, passwords, PII) even in debug mode.
3. Strip debug logging in release builds (check `kDebugMode` before logging).
