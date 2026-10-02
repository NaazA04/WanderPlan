import 'package:flutter/material.dart';

import '../main.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/attraction_card.dart';

class SavedScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onExplorePressed;

  const SavedScreen({
    super.key,
    required this.appState,
    this.onExplorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final saved = appState.savedAttractions;

        return Scaffold(
          backgroundColor: AppTheme.warmCream,
          appBar: AppBar(
            title: const Text(
              'Saved Places',
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
              child: saved.isEmpty
                  ? _emptyState(context)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      itemCount: saved.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final attraction = saved[index];

                        return AttractionCard(
                          attraction: attraction,
                          isSaved: true,
                          onSave: () {
                            appState.toggleSaved(attraction);
                          },
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.detail,
                              arguments: attraction,
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.sage.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 38,
                color: AppTheme.deepTeal,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nothing saved yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.charcoal,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save places while exploring and they\'ll appear here for quick access.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.mutedGrey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (onExplorePressed != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onExplorePressed,
                icon: const Icon(Icons.explore_outlined, size: 18),
                label: const Text('Explore Attractions'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.deepTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}