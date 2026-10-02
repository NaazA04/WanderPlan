import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'trip_setup_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({
    super.key,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final totalPlaces = appState.totalPlannedPlaces;
        final totalHours = appState.totalPlannedHours;

        return Scaffold(
          backgroundColor: AppTheme.warmCream,
          appBar: AppBar(
            title: const Text(
              'Profile & Trip',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppTheme.charcoal,
                fontSize: 22,
              ),
            ),
          ),

          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                children: [
                  // TRIP HERO CARD
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppTheme.deepTeal,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.deepTeal.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white.withValues(alpha: 0.18),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Trip',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  appState.destination,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            _stat('${appState.tripDays}', 'Days'),
                            _stat('$totalPlaces', 'Places'),
                            _stat('${appState.savedIds.length}', 'Saved'),
                            _stat('${totalHours.toStringAsFixed(1)}h', 'Est. Time'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle('TRIP SETTINGS'),

                  _tile(
                    icon: Icons.edit_location_alt_outlined,
                    title: 'Change destination or duration',
                    subtitle: 'Currently: ${appState.destination} · ${appState.tripDays} days',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripSetupScreen(appState: appState),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  _sectionTitle('LOCAL STORAGE & OFFLINE'),

                  _tile(
                    icon: Icons.cloud_done_outlined,
                    title: 'Offline persistence active',
                    subtitle: 'All itinerary and saved data are stored locally',
                    onTap: null,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.sage.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Synced',
                        style: TextStyle(
                          color: AppTheme.deepTeal,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  _sectionTitle('ABOUT'),

                  _tile(
                    icon: Icons.info_outline,
                    title: 'About WanderPlan',
                    subtitle: 'Local tourist guide & itinerary planner',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppTheme.warmCream,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.deepTeal,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.explore, color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'WanderPlan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.charcoal,
                                ),
                              ),
                            ],
                          ),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WanderPlan is a travel planner and tourist guide designed for college project submission.\n\n'
                                'Features:\n'
                                '• Destination setup (Mumbai, Goa, Jaipur)\n'
                                '• Customizable trip duration (1-14 days)\n'
                                '• Category filtering and search\n'
                                '• Interactive drag-and-drop itinerary\n'
                                '• Offline storage via SharedPreferences\n'
                                '• Favorites & detailed place guides\n\n'
                                'Version: 1.0.0',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: AppTheme.charcoal,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  color: AppTheme.deepTeal,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stat(String number, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.mutedGrey,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.sage.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.deepTeal, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppTheme.charcoal,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.mutedGrey,
              fontSize: 12,
            ),
          ),
          trailing: trailing ??
              (onTap != null
                  ? const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.mutedGrey)
                  : null),
        ),
      ),
    );
  }
}