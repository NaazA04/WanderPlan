import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/itinerary_item.dart';

class ItineraryScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onExplorePressed;

  const ItineraryScreen({
    super.key,
    required this.appState,
    this.onExplorePressed,
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Itinerary',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.charcoal,
                    fontSize: 22,
                  ),
                ),
                Text(
                  '${appState.destination} · ${appState.tripDays} ${appState.tripDays == 1 ? 'Day' : 'Days'} Trip',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                children: [
                  // TRIP SUMMARY & OFFLINE BANNER
                  Container(
                    padding: const EdgeInsets.all(20),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.offline_pin_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Saved Offline',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${appState.tripDays} Days',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _summaryStat('$totalPlaces', 'Places Planned'),
                            Container(
                              height: 32,
                              width: 1,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            _summaryStat('${totalHours.toStringAsFixed(1)} hrs', 'Est. Visit Time'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // DAY SECTIONS
                  ...List.generate(appState.tripDays, (index) {
                    final day = index + 1;
                    final places = appState.itinerary[day] ?? [];
                    final dayHours = places.fold(0.0, (sum, a) => sum + a.duration);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppTheme.deepTeal,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$day',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Day $day',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.charcoal,
                                      ),
                                    ),
                                    Text(
                                      '${places.length} ${places.length == 1 ? 'place' : 'places'}${places.isNotEmpty ? ' · ${dayHours.toStringAsFixed(1)} hrs' : ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.mutedGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (places.length > 1)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.sage.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.drag_indicator, size: 14, color: AppTheme.deepTeal),
                                    SizedBox(width: 2),
                                    Text(
                                      'Drag to reorder',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppTheme.deepTeal,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        if (places.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppTheme.sage.withValues(alpha: 0.4),
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.add_location_alt_outlined,
                                  color: AppTheme.sage.withValues(alpha: 0.8),
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Nothing planned for Day $day',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.charcoal,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Browse attractions and add them to this day.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.mutedGrey,
                                  ),
                                ),
                                if (onExplorePressed != null) ...[
                                  const SizedBox(height: 12),
                                  TextButton.icon(
                                    onPressed: onExplorePressed,
                                    icon: const Icon(Icons.explore_outlined, size: 16),
                                    label: const Text('Explore places'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppTheme.deepTeal,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        else
                          ReorderableListView(
                            buildDefaultDragHandles: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            onReorderItem: (oldIndex, newIndex) {
                              appState.reorderDay(day, oldIndex, newIndex);
                            },
                            children: places.asMap().entries.map((entry) {
                              final index = entry.key;
                              final attraction = entry.value;
                              return ReorderableDelayedDragStartListener(
                                key: ValueKey('${day}_${attraction.id}'),
                                index: index,
                                child: ItineraryItem(
                                  attraction: attraction,
                                  day: day,
                                  appState: appState,
                                ),
                              );
                            }).toList(),
                          ),

                        const SizedBox(height: 26),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _summaryStat(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
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
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}