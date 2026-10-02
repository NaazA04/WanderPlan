import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class WanderBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final int itineraryCount;

  const WanderBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.itineraryCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      indicatorColor: AppTheme.sage.withValues(alpha: 0.35),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      height: 65,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.explore_outlined, color: AppTheme.charcoal),
          selectedIcon: Icon(Icons.explore, color: AppTheme.deepTeal),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: itineraryCount > 0
              ? Badge(
                  backgroundColor: AppTheme.deepTeal,
                  label: Text(
                    '$itineraryCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Icon(Icons.map_outlined, color: AppTheme.charcoal),
                )
              : const Icon(Icons.map_outlined, color: AppTheme.charcoal),
          selectedIcon: itineraryCount > 0
              ? Badge(
                  backgroundColor: AppTheme.deepTeal,
                  label: Text(
                    '$itineraryCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Icon(Icons.map, color: AppTheme.deepTeal),
                )
              : const Icon(Icons.map, color: AppTheme.deepTeal),
          label: 'Itinerary',
        ),
        const NavigationDestination(
          icon: Icon(Icons.favorite_border, color: AppTheme.charcoal),
          selectedIcon: Icon(Icons.favorite, color: AppTheme.terracotta),
          label: 'Saved',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline, color: AppTheme.charcoal),
          selectedIcon: Icon(Icons.person, color: AppTheme.deepTeal),
          label: 'Profile',
        ),
      ],
    );
  }
}
