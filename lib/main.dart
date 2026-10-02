import 'package:flutter/material.dart';

import 'models/attraction.dart';
import 'screens/attraction_detail_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/itinerary_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/trip_setup_screen.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_bar.dart';

class AppRoutes {
  static const String home = '/';
  static const String tripSetup = '/trip-setup';
  static const String detail = '/attraction-detail';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState(autoLoad: false);
  await appState.loadData();
  runApp(WanderPlanApp(appState: appState));
}

class WanderPlanApp extends StatefulWidget {
  final AppState? appState;

  const WanderPlanApp({
    super.key,
    this.appState,
  });

  @override
  State<WanderPlanApp> createState() => _WanderPlanAppState();
}

class _WanderPlanAppState extends State<WanderPlanApp> {
  late final AppState appState;
  late final bool _internalStateCreated;

  @override
  void initState() {
    super.initState();
    if (widget.appState != null) {
      appState = widget.appState!;
      _internalStateCreated = false;
    } else {
      appState = AppState(autoLoad: true);
      _internalStateCreated = true;
    }
  }

  @override
  void dispose() {
    if (_internalStateCreated) {
      appState.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WanderPlan',
          theme: AppTheme.lightTheme,
          home: AppRoot(appState: appState),
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.tripSetup) {
              return MaterialPageRoute(
                builder: (context) => TripSetupScreen(appState: appState),
                settings: settings,
              );
            }
            if (settings.name == AppRoutes.detail) {
              final attraction = settings.arguments as Attraction;
              return MaterialPageRoute(
                builder: (context) => AttractionDetailScreen(
                  attraction: attraction,
                  appState: appState,
                ),
                settings: settings,
              );
            }
            return null;
          },
        );
      },
    );
  }
}

// ------------------------------------------------------------
// APP ROOT ROUTER
// ------------------------------------------------------------

class AppRoot extends StatelessWidget {
  final AppState appState;

  const AppRoot({
    super.key,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    if (appState.isLoading) {
      return const SplashScreen();
    }
    if (!appState.setupComplete) {
      return TripSetupScreen(appState: appState);
    }
    return MainNavigation(appState: appState);
  }
}

// ------------------------------------------------------------
// SPLASH SCREEN
// ------------------------------------------------------------

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.deepTeal,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.deepTeal.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.explore,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'WanderPlan',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppTheme.charcoal,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Personal Travel Guide',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            const CircularProgressIndicator(
              color: AppTheme.deepTeal,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// MAIN NAVIGATION
// ------------------------------------------------------------

class MainNavigation extends StatefulWidget {
  final AppState appState;

  const MainNavigation({
    super.key,
    required this.appState,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ExploreScreen(appState: widget.appState),
      ItineraryScreen(
        appState: widget.appState,
        onExplorePressed: () => _navigateToTab(0),
      ),
      SavedScreen(
        appState: widget.appState,
        onExplorePressed: () => _navigateToTab(0),
      ),
      ProfileScreen(appState: widget.appState),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: WanderBottomNavBar(
        currentIndex: currentIndex,
        onDestinationSelected: _navigateToTab,
      ),
    );
  }
}