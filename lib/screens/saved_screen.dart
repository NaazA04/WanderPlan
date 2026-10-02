import 'package:flutter/material.dart';

import '../main.dart';
import '../models/attraction.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/add_to_day_sheet.dart';

class SavedScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback? onExplorePressed;

  const SavedScreen({
    super.key,
    required this.appState,
    this.onExplorePressed,
  });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final allSaved = widget.appState.savedAttractions;

        final saved = allSaved.where((place) {
          return selectedCategory == 'All' ||
              place.category.toLowerCase() == selectedCategory.toLowerCase();
        }).toList();

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
                        32,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF133832),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'WanderPlan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'YOUR TRAVEL SHELF',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Saved Places',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Your collection of places worth exploring.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // CATEGORY FILTER CHIPS
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        height: 38,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _filterChip('All'),
                            _filterChip('Heritage'),
                            _filterChip('Scenic'),
                            _filterChip('Nature'),
                            _filterChip('Culture'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // SAVED CARDS LIST
                  if (saved.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: _emptyState(context),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      sliver: SliverList.separated(
                        itemCount: saved.length,
                        separatorBuilder: (ctx, idx) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final attraction = saved[index];
                          final countFormatted = (index + 1) < 10 ? '0${index + 1}' : '${index + 1}';
                          final isInItinerary = widget.appState.isInItinerary(attraction);

                          return _savedCard(
                            attraction: attraction,
                            numberBadge: countFormatted,
                            isInItinerary: isInItinerary,
                          );
                        },
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

  Widget _filterChip(String label) {
    final selected = selectedCategory == label;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? AppTheme.deepTeal : Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              selectedCategory = label;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppTheme.charcoal,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _savedCard({
    required Attraction attraction,
    required String numberBadge,
    required bool isInItinerary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.detail,
              arguments: attraction,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PHOTO WITH NUMBER BADGE AND FAVORITE BUTTON
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: 190,
                        width: double.infinity,
                        child: Image.network(
                          attraction.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, url, error) => Container(
                            color: AppTheme.sage.withValues(alpha: 0.25),
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined, color: AppTheme.deepTeal),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // NUMBER BADGE
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            numberBadge,
                            style: const TextStyle(
                              color: AppTheme.deepTeal,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // FAVORITE HEART BUTTON
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: const CircleBorder(),
                        elevation: 2,
                        shadowColor: Colors.black26,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            widget.appState.toggleSaved(attraction);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite,
                              size: 18,
                              color: AppTheme.deepTeal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CARD BODY
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          attraction.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.deepTeal,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: AppTheme.terracotta),
                            const SizedBox(width: 3),
                            Text(
                              '${attraction.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppTheme.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      attraction.name,
                      style: const TextStyle(
                        color: AppTheme.charcoal,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.schedule_outlined, size: 14, color: AppTheme.mutedGrey),
                        const SizedBox(width: 4),
                        Text(
                          '${attraction.duration} hr',
                          style: const TextStyle(
                            color: AppTheme.mutedGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.mutedGrey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            attraction.location,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.mutedGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ADDED TO ITINERARY BUTTON
                    Container(
                      width: double.infinity,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isInItinerary
                            ? const Color(0xFFE8F1EC)
                            : AppTheme.deepTeal,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => AddToDaySheet(
                              attraction: attraction,
                              appState: widget.appState,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isInItinerary ? Icons.check : Icons.add,
                              size: 16,
                              color: isInItinerary ? AppTheme.deepTeal : Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isInItinerary ? 'Added to itinerary' : 'Add to itinerary',
                              style: TextStyle(
                                color: isInItinerary ? AppTheme.deepTeal : Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.sage.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 34,
              color: AppTheme.deepTeal,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Nothing saved yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Save places while exploring and they\'ll appear here for quick access.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.mutedGrey,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          if (widget.onExplorePressed != null) ...[
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: widget.onExplorePressed,
              icon: const Icon(Icons.explore_outlined, size: 18),
              label: const Text('Explore Attractions'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.deepTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}