import 'package:flutter/material.dart';

import '../models/attraction.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class AddToDaySheet extends StatelessWidget {
  final Attraction attraction;
  final AppState appState;

  const AddToDaySheet({
    super.key,
    required this.attraction,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final currentDay = appState.dayContaining(attraction);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
      decoration: const BoxDecoration(
        color: AppTheme.warmCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.sage,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Text(
                currentDay != null ? 'Change itinerary day' : 'Add to which day?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.charcoal,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                attraction.name,
                style: const TextStyle(
                  color: AppTheme.mutedGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              ...List.generate(appState.tripDays, (index) {
                final day = index + 1;
                final places = appState.itinerary[day] ?? [];
                final isSelected = currentDay == day;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        await appState.addToDay(attraction, day);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${attraction.name} added to Day $day',
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppTheme.deepTeal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.deepTeal
                                    : AppTheme.sage.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$day',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.deepTeal,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Day $day',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${places.length} ${places.length == 1 ? 'place' : 'places'} planned',
                                    style: const TextStyle(
                                      color: AppTheme.mutedGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.deepTeal.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 16,
                                      color: AppTheme.deepTeal,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Added',
                                      style: TextStyle(
                                        color: AppTheme.deepTeal,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Icon(
                                Icons.add_circle_outline,
                                size: 22,
                                color: AppTheme.mutedGrey,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              if (currentDay != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      await appState.removeFromDay(attraction, currentDay);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${attraction.name} removed from Day $currentDay',
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppTheme.terracotta,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_outline, color: AppTheme.terracotta),
                    label: const Text(
                      'Remove from itinerary',
                      style: TextStyle(
                        color: AppTheme.terracotta,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}