## Project snapshot

- Language: Dart + Flutter (GetX for state & routing).
- App entry: `lib/main.dart` — loads `.env`, initializes `MySharedPref`, and uses `GetMaterialApp`.

## Quick goals for an AI code agent

- Preserve GetX patterns: controllers are registered with `Get.put(...)` and views observe state with `Obx`.
- Prefer using `MySharedPref` for theme/locale and `LocalizationService` for translations.
- Use `.env` (loaded in `lib/main.dart`) for secrets — do NOT commit API keys.

## High-level architecture & where to look

- UI / routing: `lib/app/routes/app_pages.dart` and `lib/app/modules/*` (splash, dashboard, etc.).
- State: controllers live under `lib/controllers/` (e.g. `lib/controllers/weather_controller.dart`) and sometimes under module folders — search both `lib/controllers` and `lib/app/modules` when adding controllers.
- Services: `lib/services/` (e.g. `lib/services/weather_service.dart`) provide API calls and should be side-effect free where possible.
- Models: `lib/models/` (e.g. `lib/models/weather_model.dart`) contain JSON parsing and simple DTOs.
- Local data: `lib/app/data/local/my_shared_pref.dart` centralizes SharedPreferences access — use it for theme/locale and small persisted flags.
- Config: `lib/config/` contains `my_theme.dart`, translation maps, and styling helpers — prefer updating these for global app-wide changes.

## Important code patterns (concrete examples)

- Reactive state (GetX): controllers expose Rx values. Example: `var isLoading = true.obs;` in `lib/controllers/weather_controller.dart`. Views use `Obx(() => ...)` in `lib/views/home_view.dart`.
- Controller lifecycle: perform initial fetches in `onInit()` of `GetxController` (see `WeatherController.onInit`).
- API services: use `http` client and return models via `Model.fromJson` (see `WeatherService.fetchWeatherByCity` + `WeatherModel.fromJson`).

## Secrets & env

- `lib/main.dart` loads `.env` via `flutter_dotenv`. Replace the inline API key in `lib/services/weather_service.dart` with `dotenv.env['OPENWEATHER_API_KEY']` or a similar key stored in `.env` at the repo root.
- Exact env var used by the project: `OPENWEATHER_API_KEY`.
- Add a `.env.example` with `OPENWEATHER_API_KEY=your_openweather_api_key_here` to help new developers.
- Never add secrets to source. If asked to add keys for local testing, place them in a local `.env` and document the required variables.

## Build / run / test workflows (how developers run this project)

- Install deps: `flutter pub get`.
- Run on a device/emulator: `flutter run` or `flutter run -d windows` on Windows desktop.
- Run tests: `flutter test` (project has `test/widget_test.dart`).
- Common debug spots: set breakpoints in `lib/controllers/*` and `lib/services/*` (network & state flows). Use Flutter devtools for widget tree inspection.

## Project-specific conventions & gotchas

- Mixed layout: some features live in `lib/app/*` (modules, routes) while core controllers/services/models are in top-level `lib/controllers`, `lib/services`, `lib/models`. Search both roots when adding files.
- SharedPrefs wrapper: always use `MySharedPref` for persisted settings; do not access `SharedPreferences` directly in multiple places.
- Theme toggling uses `MyTheme.changeTheme()` and persists via `MySharedPref.setTheme(...)` — prefer that flow for theme changes.
- Localization: update translation maps under `lib/config/translations/*` and use `LocalizationService.updateLanguage(...)` to change language at runtime.

## Integration points to be careful about

- OpenWeather API: `lib/services/weather_service.dart` - endpoints use `units=metric`. Verify rate limits and error handling; currently non-200 responses throw a generic `Exception`.
- Shared preferences and locale interplay: `MySharedPref.getLocale()` is used by `GetMaterialApp.locale` in `main.dart` — changing locale at runtime uses `LocalizationService`.

## When editing code, prefer these small improvements

- Replace inline API keys with `dotenv.env[...]` and add a README note listing required `.env` variables.
- Improve error messages from `WeatherService` to return structured errors (so `WeatherController` can show better UI guidance).
- Add unit tests for `WeatherModel.fromJson` and a minimal integration test that mocks `http` for `WeatherService`.

## Files to reference when making changes

- Entry point: `lib/main.dart`
- Routes: `lib/app/routes/app_pages.dart`
- Controller example: `lib/controllers/weather_controller.dart`
- Service example: `lib/services/weather_service.dart`
- Model example: `lib/models/weather_model.dart`
- Shared prefs wrapper: `lib/app/data/local/my_shared_pref.dart`
- Theme & translations: `lib/config/my_theme.dart`, `lib/config/translations/`

If anything above is unclear or you'd like me to tailor instructions for tests, CI configuration, or to enforce stricter linting rules, tell me which area to expand. 
