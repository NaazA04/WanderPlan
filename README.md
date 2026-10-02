# 🌍 WanderPlan

**Your Personal Travel Guide** — a Flutter app for exploring destinations, planning day-by-day itineraries, and saving your favourite attractions.

---

## ✨ Features

- **Trip Setup** — Choose your destination (Mumbai, Goa, Jaipur) and set the number of travel days
- **Explore** — Browse attractions filtered by category (Temples, Beaches, Food, Museums, etc.) with search support
- **Itinerary Planner** — Drag attractions into day slots to build a personalised day-by-day plan
- **Saved Places** — Bookmark attractions to revisit later
- **Attraction Detail** — View ratings, estimated visit duration, location, and description for each place
- **Persistent State** — Trip setup and saved data are stored locally via `shared_preferences` so your plan survives app restarts

---

## 📱 Screens

| Screen | Description |
|---|---|
| `TripSetupScreen` | Onboarding flow to pick destination & trip length |
| `ExploreScreen` | Searchable, filterable list of attractions |
| `ItineraryScreen` | Day-by-day planner with add/remove support |
| `SavedScreen` | Bookmarked attractions |
| `AttractionDetailScreen` | Full detail view for an attraction |
| `ProfileScreen` | User profile & trip summary |

---

## 🏗️ Project Structure

```
lib/
├── main.dart                   # App entry point & routing
├── models/
│   └── attraction.dart         # Attraction data model
├── data/
│   └── attractions.dart        # Static attraction data for all destinations
├── services/
│   └── app_state.dart          # Central state (ChangeNotifier) with persistence
├── screens/
│   ├── explore_screen.dart
│   ├── itinerary_screen.dart
│   ├── saved_screen.dart
│   ├── trip_setup_screen.dart
│   ├── attraction_detail_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── bottom_nav_bar.dart
│   ├── attraction_card.dart
│   ├── itinerary_item.dart
│   └── add_to_day_sheet.dart
└── theme/
    └── app_theme.dart          # Colours, text styles, and Material theme
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) SDK `^3.13.2`
- Dart SDK `^3.13.2`

### Run the app

```bash
# Install dependencies
flutter pub get

# Run on a connected device or simulator
flutter run
```

### Supported platforms

| Platform | Status |
|---|---|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Persist trip setup, itinerary, and saved places locally |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | iOS-style icon set |

---

## 🎨 Theme

The app uses a warm, earthy palette defined in `lib/theme/app_theme.dart`:

- **Deep Teal** — primary accent
- **Warm Cream** — background
- **Charcoal** — headings
- **Muted Grey** — secondary text

---



