import 'package:flutter/material.dart';

import '../main.dart';
import '../models/attraction.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'add_to_day_sheet.dart';

class ItineraryItem extends StatelessWidget {
  final Attraction attraction;
  final int day;
  final int index;
  final AppState appState;

  const ItineraryItem({
    super.key,
    required this.attraction,
    required this.day,
    required this.index,
    required this.appState,
  });

  String _getTimeForIndex(int idx) {
    final startHour = 9 + (idx * 2);
    final formatted = startHour < 10 ? '0$startHour:00' : '$startHour:00';
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
                // TIME PILL
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    _getTimeForIndex(index),
                    style: const TextStyle(
                      color: AppTheme.deepTeal,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // THUMBNAIL PHOTO
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    attraction.imageUrl,
                    width: 68,
                    height: 68,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 68,
                        height: 68,
                        color: AppTheme.sage.withValues(alpha: 0.2),
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
                        width: 68,
                        height: 68,
                        color: AppTheme.sage.withValues(alpha: 0.25),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 24,
                          color: AppTheme.deepTeal,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // DETAILS
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
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        attraction.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.charcoal,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 13,
                            color: AppTheme.mutedGrey,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${attraction.duration} hr',
                            style: const TextStyle(
                              color: AppTheme.mutedGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppTheme.terracotta,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${attraction.rating}',
                            style: const TextStyle(
                              color: AppTheme.mutedGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ACTIONS COLUMN
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MOVE TO ANOTHER DAY
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
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
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.drive_file_move_outline,
                          size: 18,
                          color: AppTheme.mutedGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // REMOVE BUTTON
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        await appState.removeFromDay(attraction, day);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppTheme.mutedGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
