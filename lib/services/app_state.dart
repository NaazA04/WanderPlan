import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/attractions.dart';
import '../models/attraction.dart';

class AppState extends ChangeNotifier {
  String destination = 'Mumbai';
  int tripDays = 3;
  bool setupComplete = false;

  final Map<int, List<Attraction>> itinerary = {};
  final Set<String> savedIds = {};

  bool isLoading = true;

  AppState({bool autoLoad = true}) {
    if (autoLoad) {
      loadData();
    }
  }

  // ----------------------------------------------------------
  // LOAD SAVED DATA
  // ----------------------------------------------------------

  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      final storedSetupComplete = prefs.getBool('setupComplete');
      final storedDestination = prefs.getString('destination');
      final storedTripDays = prefs.getInt('tripDays');

      if (storedSetupComplete != null) {
        setupComplete = storedSetupComplete;
      }
      if (storedDestination != null && storedDestination.isNotEmpty) {
        destination = storedDestination;
      }
      if (storedTripDays != null && storedTripDays > 0) {
        tripDays = storedTripDays;
      }

      savedIds.clear();
      List<String>? saved;
      try {
        saved = prefs.getStringList('savedIds');
      } catch (_) {}
      if (saved != null) {
        savedIds.addAll(saved);
      } else {
        final rawSaved = prefs.getString('savedIds');
        if (rawSaved != null && rawSaved.isNotEmpty) {
          try {
            final decoded = jsonDecode(rawSaved);
            if (decoded is List) {
              savedIds.addAll(decoded.map((e) => e.toString()));
            }
          } catch (_) {}
        }
      }

      itinerary.clear();
      for (int day = 1; day <= (tripDays > 0 ? tripDays : 3); day++) {
        itinerary[day] = [];
      }

      final itineraryString = prefs.getString('itinerary');
      if (itineraryString != null && itineraryString.isNotEmpty) {
        try {
          final decoded = jsonDecode(itineraryString);
          if (decoded is Map) {
            for (final entry in decoded.entries) {
              final day = int.tryParse(entry.key.toString());
              if (day == null || day < 1 || day > tripDays) continue;

              final ids = List<dynamic>.from(entry.value as Iterable)
                  .map((e) => e.toString())
                  .toList();
              itinerary[day] = ids
                  .map((id) {
                    try {
                      return attractions.firstWhere((a) => a.id == id);
                    } catch (_) {
                      return null;
                    }
                  })
                  .whereType<Attraction>()
                  .toList();
            }
          }
        } catch (e) {
          debugPrint('Error decoding itinerary JSON: $e');
        }
      }
    } catch (e) {
      debugPrint('Error loading saved state: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ----------------------------------------------------------
  // CREATE / UPDATE TRIP
  // ----------------------------------------------------------

  Future<void> createTrip({
    required String newDestination,
    required int days,
  }) async {
    final destinationChanged = destination != newDestination;
    destination = newDestination;
    tripDays = days;
    setupComplete = true;

    // If destination changed, reinitialize itinerary.
    // If only days changed, retain attractions for existing days and prune extra days.
    if (destinationChanged) {
      itinerary.clear();
      for (int day = 1; day <= days; day++) {
        itinerary[day] = [];
      }
    } else {
      // Keep valid days and create new empty days if duration expanded
      final Map<int, List<Attraction>> updatedItinerary = {};
      for (int day = 1; day <= days; day++) {
        updatedItinerary[day] = itinerary[day] ?? [];
      }
      itinerary.clear();
      itinerary.addAll(updatedItinerary);
    }

    await saveData();
    notifyListeners();
  }

  // ----------------------------------------------------------
  // SAVE DATA
  // ----------------------------------------------------------

  Future<void> saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('destination', destination);
      await prefs.setInt('tripDays', tripDays);
      await prefs.setBool('setupComplete', setupComplete);
      await prefs.setStringList('savedIds', savedIds.toList());

      final Map<String, List<String>> itineraryData = {};
      for (final entry in itinerary.entries) {
        itineraryData[entry.key.toString()] =
            entry.value.map((a) => a.id).toList();
      }

      final jsonString = jsonEncode(itineraryData);
      await prefs.setString('itinerary', jsonString);
    } catch (e) {
      debugPrint('Error saving state: $e');
    }
  }

  // ----------------------------------------------------------
  // DESTINATION ATTRACTIONS & STATS
  // ----------------------------------------------------------

  List<Attraction> get destinationAttractions {
    return attractions
        .where((a) => a.destination.toLowerCase() == destination.toLowerCase())
        .toList();
  }

  int get totalPlannedPlaces {
    return itinerary.values.fold(0, (sum, list) => sum + list.length);
  }

  double get totalPlannedHours {
    return itinerary.values
        .expand((list) => list)
        .fold(0.0, (sum, a) => sum + a.duration);
  }

  // ----------------------------------------------------------
  // SAVED PLACES
  // ----------------------------------------------------------

  bool isSaved(Attraction attraction) {
    return savedIds.contains(attraction.id);
  }

  Future<void> toggleSaved(Attraction attraction) async {
    if (savedIds.contains(attraction.id)) {
      savedIds.remove(attraction.id);
    } else {
      savedIds.add(attraction.id);
    }

    await saveData();
    notifyListeners();
  }

  List<Attraction> get savedAttractions {
    return attractions.where((a) => savedIds.contains(a.id)).toList();
  }

  // ----------------------------------------------------------
  // ITINERARY
  // ----------------------------------------------------------

  bool isInItinerary(Attraction attraction) {
    return itinerary.values.any(
      (day) => day.any((a) => a.id == attraction.id),
    );
  }

  int? dayContaining(Attraction attraction) {
    for (final entry in itinerary.entries) {
      if (entry.value.any((a) => a.id == attraction.id)) {
        return entry.key;
      }
    }
    return null;
  }

  Future<void> addToDay(Attraction attraction, int day) async {
    if (!itinerary.containsKey(day)) {
      itinerary[day] = [];
    }

    // Don't add duplicate in any day
    removeFromAllDays(attraction);
    itinerary[day]!.add(attraction);

    await saveData();
    notifyListeners();
  }

  Future<void> removeFromDay(Attraction attraction, int day) async {
    itinerary[day]?.removeWhere((a) => a.id == attraction.id);

    await saveData();
    notifyListeners();
  }

  void removeFromAllDays(Attraction attraction) {
    for (final day in itinerary.values) {
      day.removeWhere((a) => a.id == attraction.id);
    }
  }

  Future<void> moveAttraction(
    Attraction attraction,
    int fromDay,
    int toDay,
    int newIndex,
  ) async {
    final source = itinerary[fromDay] ?? [];
    source.removeWhere((a) => a.id == attraction.id);

    final target = itinerary[toDay] ??= [];
    final safeIndex = newIndex.clamp(0, target.length);
    target.insert(safeIndex, attraction);

    await saveData();
    notifyListeners();
  }

  Future<void> reorderDay(int day, int oldIndex, int newIndex) async {
    final list = itinerary[day] ?? [];
    if (oldIndex < 0 || oldIndex >= list.length) return;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final safeNewIndex = newIndex.clamp(0, list.length - 1);

    final item = list.removeAt(oldIndex);
    list.insert(safeNewIndex, item);

    await saveData();
    notifyListeners();
  }
}
