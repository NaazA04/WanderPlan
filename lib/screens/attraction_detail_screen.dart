import 'package:flutter/material.dart';

import '../models/attraction.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/add_to_day_sheet.dart';

class AttractionDetailScreen extends StatelessWidget {
  final Attraction attraction;
  final AppState appState;

  const AttractionDetailScreen({
    super.key,
    required this.attraction,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final isSaved = appState.isSaved(attraction);
        final assignedDay = appState.dayContaining(attraction);

        return Scaffold(
          backgroundColor: AppTheme.warmCream,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 330,
                    pinned: true,
                    backgroundColor: AppTheme.deepTeal,
                    foregroundColor: Colors.white,
                    leading: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.85),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.charcoal),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            attraction.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppTheme.deepTeal,
                                child: const Center(
                                  child: CircularProgressIndicator(color: Colors.white),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.deepTeal,
                                child: const Center(
                                  child: Icon(
                                    Icons.landscape,
                                    size: 50,
                                    color: Colors.white70,
                                  ),
                                ),
                              );
                            },
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.35),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.65),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          child: IconButton(
                            tooltip: isSaved ? 'Remove from saved' : 'Save attraction',
                            onPressed: () {
                              appState.toggleSaved(attraction);
                            },
                            icon: Icon(
                              isSaved ? Icons.favorite : Icons.favorite_border,
                              color: isSaved ? AppTheme.terracotta : AppTheme.charcoal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.deepTeal.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  attraction.category.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.deepTeal,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              if (assignedDay != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.sage.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        size: 14,
                                        color: AppTheme.deepTeal,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'In Day $assignedDay',
                                        style: const TextStyle(
                                          color: AppTheme.deepTeal,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            attraction.name,
                            style: const TextStyle(
                              color: AppTheme.charcoal,
                              fontSize: 30,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              _info(Icons.star_rounded, '${attraction.rating} Rating'),
                              _info(Icons.schedule_outlined, '${attraction.duration} hrs'),
                              Expanded(
                                child: _info(Icons.location_on_outlined, attraction.location),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          const Text(
                            'About this place',
                            style: TextStyle(
                              color: AppTheme.charcoal,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            attraction.description,
                            style: const TextStyle(
                              color: AppTheme.mutedGrey,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 28),

                          const Text(
                            'Good to know',
                            style: TextStyle(
                              color: AppTheme.charcoal,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                _goodToKnow(
                                  Icons.schedule,
                                  'Visit time',
                                  '${attraction.duration} hrs',
                                ),
                                _goodToKnow(
                                  Icons.location_on_outlined,
                                  'Location',
                                  attraction.location,
                                ),
                                _goodToKnow(
                                  Icons.wb_sunny_outlined,
                                  'Best time',
                                  'Morning',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => AddToDaySheet(
                                    attraction: attraction,
                                    appState: appState,
                                  ),
                                );
                              },
                              icon: Icon(assignedDay != null ? Icons.edit_calendar : Icons.add),
                              label: Text(
                                assignedDay != null
                                    ? 'Change itinerary day (Day $assignedDay)'
                                    : 'Add to itinerary',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.deepTeal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.deepTeal,
                                side: const BorderSide(color: AppTheme.sage),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Back to exploring',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
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

  Widget _info(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.terracotta),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.mutedGrey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goodToKnow(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppTheme.deepTeal, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.mutedGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.charcoal,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}