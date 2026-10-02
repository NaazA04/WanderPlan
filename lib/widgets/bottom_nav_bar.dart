import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class WanderBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const WanderBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      indicatorColor: AppTheme.sage.withValues(alpha: 0.3),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.explore_outlined, color: AppTheme.charcoal),
          selectedIcon: Icon(Icons.explore, color: AppTheme.deepTeal),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(Icons.map_outlined, color: AppTheme.charcoal),
          selectedIcon: Icon(Icons.map, color: AppTheme.deepTeal),
          label: 'Itinerary',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border, color: AppTheme.charcoal),
          selectedIcon: Icon(Icons.favorite, color: AppTheme.terracotta),
          label: 'Saved',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: AppTheme.charcoal),
          selectedIcon: Icon(Icons.person, color: AppTheme.deepTeal),
          label: 'Profile',
        ),
      ],
    );
  }
}
