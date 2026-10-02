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
          backgroundColor: Colors.white,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: CustomScrollView(
                slivers: [
                  // FULL BLEED SCENIC IMAGE WITH FLOATING ACTIONS
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 380,
                          width: double.infinity,
                          child: Image.network(
                            attraction.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, url, error) => Container(
                              color: AppTheme.deepTeal,
                              child: const Center(
                                child: Icon(Icons.landscape, size: 60, color: Colors.white70),
                              ),
                            ),
                          ),
                        ),

                        // TOP NAVIGATION BUTTONS
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 18,
                          right: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white.withValues(alpha: 0.9),
                                radius: 20,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.arrow_back, color: AppTheme.charcoal, size: 20),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white.withValues(alpha: 0.9),
                                radius: 20,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    isSaved ? Icons.favorite : Icons.favorite_border,
                                    color: isSaved ? AppTheme.deepTeal : AppTheme.charcoal,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    appState.toggleSaved(attraction);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // COLLECTION PILL TAG
                        Positioned(
                          bottom: 24,
                          right: 18,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${attraction.destination} collection',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ATTRACTION DETAILS CONTENT
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -16),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(22, 24, 22, 36),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CATEGORY
                            Text(
                              attraction.category.toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.deepTeal,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.4,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // TITLE
                            Text(
                              attraction.name,
                              style: const TextStyle(
                                color: AppTheme.charcoal,
                                fontSize: 30,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 3-COLUMN STATS BAR
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  _statCol(
                                    icon: Icons.star_rounded,
                                    iconColor: AppTheme.terracotta,
                                    topText: '${attraction.rating}',
                                    bottomText: 'Rating',
                                  ),
                                  Container(height: 26, width: 1, color: Colors.black12),
                                  _statCol(
                                    icon: Icons.schedule,
                                    iconColor: AppTheme.deepTeal,
                                    topText: '${attraction.duration} hr',
                                    bottomText: 'Visit',
                                  ),
                                  Container(height: 26, width: 1, color: Colors.black12),
                                  _statCol(
                                    icon: Icons.location_on_outlined,
                                    iconColor: AppTheme.deepTeal,
                                    topText: attraction.location.split(',').first.trim(),
                                    bottomText: attraction.destination,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 26),

                            // ABOUT THIS PLACE
                            const Text(
                              'About this place',
                              style: TextStyle(
                                color: AppTheme.charcoal,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // PRIMARY ITINERARY ACTION BUTTON
                            if (assignedDay != null) ...[
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD8E5DF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check_circle_outline, color: AppTheme.deepTeal, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Added to Day $assignedDay',
                                        style: const TextStyle(
                                          color: AppTheme.deepTeal,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Text(
                                    'View itinerary',
                                    style: TextStyle(
                                      color: AppTheme.deepTeal,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  label: const Icon(Icons.arrow_forward, size: 14, color: AppTheme.deepTeal),
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                width: double.infinity,
                                height: 50,
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
                                  icon: const Icon(Icons.add, size: 20),
                                  label: const Text(
                                    'Add to itinerary',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
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
                              const SizedBox(height: 14),
                            ],

                            const SizedBox(height: 12),

                            // LEAD DESCRIPTION
                            Text(
                              'Arrive early for soft light and a quieter promenade.',
                              style: TextStyle(
                                color: AppTheme.charcoal.withValues(alpha: 0.9),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // FULL BODY DESCRIPTION
                            Text(
                              attraction.description,
                              style: const TextStyle(
                                color: AppTheme.mutedGrey,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // GOOD TO KNOW
                            const Text(
                              'Good to know',
                              style: TextStyle(
                                color: AppTheme.charcoal,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppTheme.warmCream,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  _goodToKnowBox(
                                    icon: Icons.wb_sunny_outlined,
                                    label: 'Best time',
                                    value: 'Morning / Evening',
                                  ),
                                  _goodToKnowBox(
                                    icon: Icons.schedule,
                                    label: 'Visit duration',
                                    value: '${attraction.duration} hr',
                                  ),
                                  _goodToKnowBox(
                                    icon: Icons.location_on_outlined,
                                    label: 'Location',
                                    value: attraction.location.split(',').first.trim(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Widget _statCol({
    required IconData icon,
    required Color iconColor,
    required String topText,
    required String bottomText,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  topText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppTheme.charcoal,
                  ),
                ),
                Text(
                  bottomText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _goodToKnowBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.sage.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppTheme.deepTeal),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.mutedGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.charcoal,
            ),
          ),
        ],
      ),
    );
  }
}