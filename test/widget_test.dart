import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderplan/data/attractions.dart';
import 'package:wanderplan/main.dart';
import 'package:wanderplan/services/app_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Full persistence verification across app restarts', (WidgetTester tester) async {
    // 1. Fresh launch - verify Trip Setup is shown
    final appState1 = AppState(autoLoad: false);
    await appState1.loadData();
    expect(appState1.setupComplete, false);

    await tester.pumpWidget(WanderPlanApp(appState: appState1));
    await tester.pumpAndSettle();

    expect(find.textContaining('Let\'s plan'), findsOneWidget);
    expect(find.text('Mumbai'), findsOneWidget);

    // 2. Create trip: Mumbai, 3 days
    await appState1.createTrip(newDestination: 'Mumbai', days: 3);
    await tester.pumpAndSettle();

    expect(find.text('WanderPlan'), findsOneWidget);
    expect(find.text('Places to explore'), findsOneWidget);

    // 3. Add an attraction to Day 1, another to Day 2, and save an attraction
    final gateway = attractions.firstWhere((a) => a.id == 'gateway');
    final marineDrive = attractions.firstWhere((a) => a.id == 'marine-drive');
    final cst = attractions.firstWhere((a) => a.id == 'cst');

    await appState1.addToDay(gateway, 1);
    await appState1.addToDay(marineDrive, 2);
    await appState1.toggleSaved(cst);

    expect(appState1.itinerary[1]!.any((a) => a.id == 'gateway'), true);
    expect(appState1.itinerary[2]!.any((a) => a.id == 'marine-drive'), true);
    expect(appState1.isSaved(cst), true);

    // 4. Simulate complete app restart (new AppState loading from SharedPreferences)
    final appState2 = AppState(autoLoad: false);
    await appState2.loadData();

    // Verify state restored correctly
    expect(appState2.setupComplete, true);
    expect(appState2.destination, 'Mumbai');
    expect(appState2.tripDays, 3);
    expect(appState2.itinerary[1]!.length, 1);
    expect(appState2.itinerary[1]!.first.id, 'gateway');
    expect(appState2.itinerary[2]!.length, 1);
    expect(appState2.itinerary[2]!.first.id, 'marine-drive');
    expect(appState2.isSaved(cst), true);

    // 5. Mount restored app and verify TripSetupScreen is NOT shown
    await tester.pumpWidget(WanderPlanApp(appState: appState2));
    await tester.pumpAndSettle();

    // Verify directly on MainNavigation/Explore and not TripSetupScreen
    expect(find.textContaining('Let\'s plan'), findsNothing);
    expect(find.text('WanderPlan'), findsOneWidget);
    expect(find.text('Places to explore'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Itinerary'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
