import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'trip_setup_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppState appState;

  const ProfileScreen({
    super.key,
    required this.appState,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Set<String> _selectedPreferences = {'Heritage', 'Nature', 'Scenic'};

  void _togglePreference(String pref) {
    setState(() {
      if (_selectedPreferences.contains(pref)) {
        _selectedPreferences.remove(pref);
      } else {
        _selectedPreferences.add(pref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final totalPlaces = widget.appState.totalPlannedPlaces;
        final savedCount = widget.appState.savedIds.length;

        return Scaffold(
          backgroundColor: AppTheme.warmCream,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: CustomScrollView(
                slivers: [
                  // DARK FOREST GREEN HEADER
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        22,
                        MediaQuery.of(context).padding.top + 14,
                        22,
                        36,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF133832),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'WanderPlan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white.withValues(alpha: 0.15),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TripSetupScreen(appState: widget.appState),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // USER AVATAR & NAME
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                                ),
                                child: const CircleAvatar(
                                  radius: 36,
                                  backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'YOUR WANDERPLAN',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Aanya Mehta',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Planning your next adventure?',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // FLOATING 3-METRIC SUMMARY CARD
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            _metricItem('${widget.appState.tripDays}', 'TRIPS PLANNED'),
                            Container(height: 28, width: 1, color: Colors.black12),
                            _metricItem('${totalPlaces > 0 ? totalPlaces : 5}', 'PLACES EXPLORED'),
                            Container(height: 28, width: 1, color: Colors.black12),
                            _metricItem('$savedCount', 'PLACES SAVED'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // SECTION: MY PREFERENCES
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MY PREFERENCES',
                            style: TextStyle(
                              color: AppTheme.deepTeal,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Travel preferences',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.charcoal,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _prefChip('Heritage', Icons.account_balance_outlined),
                              _prefChip('Nature', Icons.park_outlined),
                              _prefChip('Scenic', Icons.waves_outlined),
                              _prefChip('Culture', Icons.theater_comedy_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // SECTION: APP (OFFLINE & STORAGE)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'APP',
                            style: TextStyle(
                              color: AppTheme.deepTeal,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Offline & storage',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.charcoal,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // GROUPED SETTINGS CONTAINER
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _settingTile(
                                  icon: Icons.check,
                                  iconBg: const Color(0xFFD8E5DF),
                                  iconColor: AppTheme.deepTeal,
                                  title: 'Offline itinerary',
                                  subtitle: 'Last saved: Today',
                                  onTap: () {},
                                ),
                                const Divider(height: 1, indent: 64),
                                _settingTile(
                                  icon: Icons.notifications_none_outlined,
                                  iconBg: AppTheme.warmCream,
                                  iconColor: AppTheme.deepTeal,
                                  title: 'Notifications',
                                  subtitle: 'Trip reminders and updates',
                                  onTap: () {},
                                ),
                                const Divider(height: 1, indent: 64),
                                _settingTile(
                                  icon: Icons.contrast,
                                  iconBg: AppTheme.warmCream,
                                  iconColor: AppTheme.deepTeal,
                                  title: 'Appearance',
                                  subtitle: 'System default',
                                  onTap: () {},
                                ),
                                const Divider(height: 1, indent: 64),
                                _settingTile(
                                  icon: Icons.info_outline,
                                  iconBg: AppTheme.warmCream,
                                  iconColor: AppTheme.deepTeal,
                                  title: 'About WanderPlan',
                                  subtitle: 'Version 1.0',
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        backgroundColor: AppTheme.warmCream,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        title: const Text(
                                          'WanderPlan',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.charcoal,
                                          ),
                                        ),
                                        content: const Text(
                                          'Local tourist guide & itinerary planner app for college project submission.\n\nOffline enabled via local browser storage.',
                                          style: TextStyle(fontSize: 14, color: AppTheme.charcoal),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text('Close', style: TextStyle(color: AppTheme.deepTeal, fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _metricItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppTheme.mutedGrey,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _prefChip(String label, IconData icon) {
    final selected = _selectedPreferences.contains(label);

    return Material(
      color: selected ? const Color(0xFFD8E5DF) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? AppTheme.deepTeal.withValues(alpha: 0.4) : Colors.black12,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _togglePreference(label),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: selected ? AppTheme.deepTeal : AppTheme.charcoal),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppTheme.deepTeal : AppTheme.charcoal,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 4),
                const Icon(Icons.check, size: 14, color: AppTheme.deepTeal),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppTheme.charcoal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.mutedGrey,
          ),
        ),
        trailing: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1EC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.arrow_forward_ios, size: 11, color: AppTheme.deepTeal),
        ),
      ),
    );
  }
}