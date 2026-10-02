import 'package:flutter/material.dart';

import '../models/attraction.dart';
import '../theme/app_theme.dart';

class AttractionCard extends StatelessWidget {
  final Attraction attraction;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool isSaved;

  const AttractionCard({
    super.key,
    required this.attraction,
    this.onTap,
    this.onSave,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: Image.network(
                    attraction.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
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
                        color: AppTheme.sage.withValues(alpha: 0.25),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: AppTheme.deepTeal,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: isSaved ? 'Remove from saved' : 'Save attraction',
                      onPressed: onSave,
                      icon: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        color: isSaved
                            ? AppTheme.terracotta
                            : AppTheme.charcoal,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.deepTeal,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    attraction.name,
                    style: const TextStyle(
                      color: AppTheme.charcoal,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 17,
                        color: AppTheme.terracotta,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        attraction.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: AppTheme.mutedGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${attraction.duration} hrs',
                        style: const TextStyle(
                          color: AppTheme.mutedGrey,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppTheme.mutedGrey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          attraction.location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.mutedGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}