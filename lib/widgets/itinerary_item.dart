import 'package:flutter/material.dart';

import '../main.dart';
import '../models/attraction.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'add_to_day_sheet.dart';

class ItineraryItem extends StatelessWidget {
  final Attraction attraction;
  final int day;
  final AppState appState;

  const ItineraryItem({
    super.key,
    required this.attraction,
    required this.day,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.detail,
              arguments: attraction,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    attraction.imageUrl,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 78,
                        height: 78,
                        color: AppTheme.sage.withValues(alpha: 0.15),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.deepTeal,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 78,
                        height: 78,
                        color: AppTheme.sage.withValues(alpha: 0.25),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppTheme.deepTeal,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attraction.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.deepTeal,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        attraction.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.charcoal,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 14,
                            color: AppTheme.mutedGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${attraction.duration} hrs',
                            style: const TextStyle(
                              color: AppTheme.mutedGrey,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppTheme.terracotta,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${attraction.rating}',
                            style: const TextStyle(
                              color: AppTheme.mutedGrey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                IconButton(
                  tooltip: 'Options',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                      ),
                      builder: (sheetContext) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppTheme.deepTeal,
                                  ),
                                  title: const Text('Move to another day'),
                                  onTap: () {
                                    Navigator.pop(sheetContext);
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
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.delete_outline,
                                    color: AppTheme.terracotta,
                                  ),
                                  title: const Text(
                                    'Remove from itinerary',
                                    style: TextStyle(color: AppTheme.terracotta),
                                  ),
                                  onTap: () async {
                                    await appState.removeFromDay(attraction, day);
                                    if (sheetContext.mounted) {
                                      Navigator.pop(sheetContext);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
