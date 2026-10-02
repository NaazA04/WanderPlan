import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/itinerary_item.dart';
import 'trip_setup_screen.dart';

class ItineraryScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onExplorePressed;

  const ItineraryScreen({
    super.key,
    required this.appState,
    this.onExplorePressed,
  });

  String _getDaySubtitle(int day, String destination) {
    if (destination.toLowerCase() == 'mumbai') {
      const subtitles = ['South Mumbai', 'Island & heritage', 'Forest escape', 'Coast & nightlife', 'Culture & bazaars'];
      return subtitles[(day - 1) % subtitles.length];
    } else if (destination.toLowerCase() == 'goa') {
      const subtitles = ['North beaches', 'Old Goa heritage', 'Waterfalls & spice', 'South coastline', 'Panjim vibes'];
      return subtitles[(day - 1) % subtitles.length];
    } else {
      const subtitles = ['Pink city forts', 'Palaces & bazaars', 'Aravalli sunsets', 'Heritage landmarks', 'Royal gardens'];
      return subtitles[(day - 1) % subtitles.length];
    }
  }

  void _showAddAttractionPicker(BuildContext context, int day) {
    final available = appState.destinationAttractions;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          decoration: const BoxDecoration(
            color: AppTheme.warmCream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.sage,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Add to Day $day',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select an attraction in ${appState.destination}',
                  style: const TextStyle(
                    color: AppTheme.mutedGrey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: available.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final attraction = available[index];
                      final isInThisDay = (appState.itinerary[day] ?? []).any((a) => a.id == attraction.id);

                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: ListTile(
                          onTap: () async {
                            await appState.addToDay(attraction, day);
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              attraction.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            attraction.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          subtitle: Text(
                            '${attraction.category} · ${attraction.duration} hr',
                            style: const TextStyle(fontSize: 11, color: AppTheme.mutedGrey),
                          ),
                          trailing: Icon(
                            isInThisDay ? Icons.check_circle : Icons.add_circle_outline,
                            color: isInThisDay ? AppTheme.deepTeal : AppTheme.mutedGrey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final totalPlaces = appState.totalPlannedPlaces;
        final totalHours = appState.totalPlannedHours;

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
                                  icon: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TripSetupScreen(appState: appState),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'MY ITINERARY',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${appState.destination} · ${appState.tripDays} days',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.check,
                                size: 14,
                                color: Color(0xFF8FAFA5),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Saved offline',
                                style: TextStyle(
                                  color: Color(0xFF8FAFA5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
                            _metricItem('$totalPlaces', 'PLACES'),
                            Container(height: 28, width: 1, color: Colors.black12),
                            _metricItem(totalHours.toStringAsFixed(1), 'HRS PLANNED'),
                            Container(height: 28, width: 1, color: Colors.black12),
                            _metricItem('${appState.tripDays}', 'DAYS'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // SUB-INSTRUCTION: HOLD AND DRAG
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
                      child: Row(
                        children: const [
                          Icon(Icons.drag_indicator, size: 14, color: AppTheme.mutedGrey),
                          SizedBox(width: 4),
                          Text(
                            'Hold and drag to reorder',
                            style: TextStyle(
                              color: AppTheme.mutedGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // DAY TIMELINE SECTIONS
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final day = index + 1;
                          final places = appState.itinerary[day] ?? [];
                          final dayFormatted = day < 10 ? 'Day 0$day' : 'Day $day';
                          final subtitle = _getDaySubtitle(day, appState.destination);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TIMELINE CIRCLE & VERTICAL LINE
                                Column(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.deepTeal,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$day',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: places.isEmpty ? 100 : (places.length * 105.0 + 50),
                                      color: AppTheme.sage.withValues(alpha: 0.3),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 14),

                                // DAY CONTENT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // DAY HEADER
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dayFormatted,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppTheme.charcoal,
                                                  letterSpacing: -0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                subtitle,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppTheme.mutedGrey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${places.length} ${places.length == 1 ? 'stop' : 'stops'}',
                                            style: const TextStyle(
                                              color: AppTheme.mutedGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // ATTRACTION CARDS OR EMPTY
                                      if (places.isNotEmpty)
                                        ReorderableListView(
                                          buildDefaultDragHandles: false,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          onReorderItem: (oldIndex, newIndex) {
                                            appState.reorderDay(day, oldIndex, newIndex);
                                          },
                                          children: places.asMap().entries.map((entry) {
                                            final itemIndex = entry.key;
                                            final attraction = entry.value;
                                            return ReorderableDelayedDragStartListener(
                                              key: ValueKey('${day}_${attraction.id}'),
                                              index: itemIndex,
                                              child: ItineraryItem(
                                                attraction: attraction,
                                                day: day,
                                                index: itemIndex,
                                                appState: appState,
                                              ),
                                            );
                                          }).toList(),
                                        ),

                                      // ADD ATTRACTION OUTLINE BUTTON
                                      SizedBox(
                                        width: double.infinity,
                                        height: 44,
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            _showAddAttractionPicker(context, day);
                                          },
                                          icon: const Icon(Icons.add, size: 16, color: AppTheme.deepTeal),
                                          label: const Text(
                                            'Add attraction',
                                            style: TextStyle(
                                              color: AppTheme.deepTeal,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white.withValues(alpha: 0.5),
                                            side: BorderSide(
                                              color: AppTheme.deepTeal.withValues(alpha: 0.35),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: appState.tripDays,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
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
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.mutedGrey,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}