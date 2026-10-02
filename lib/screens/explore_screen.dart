import 'package:flutter/material.dart';

import '../main.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/attraction_card.dart';

class ExploreScreen extends StatefulWidget {
  final AppState appState;

  const ExploreScreen({
    super.key,
    required this.appState,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getDestinationHeroImage(String destination) {
    switch (destination.toLowerCase()) {
      case 'goa':
        return 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2';
      case 'jaipur':
        return 'https://images.unsplash.com/photo-1599661046289-e31897846e41';
      case 'mumbai':
      default:
        return 'https://images.unsplash.com/photo-1570168007204-dfb528c6958f';
    }
  }

  @override
  Widget build(BuildContext context) {
    final allPlaces = widget.appState.destinationAttractions;

    final places = allPlaces.where((place) {
      final categoryMatch =
          selectedCategory == 'All' || place.category.toLowerCase() == selectedCategory.toLowerCase();

      final searchMatch = searchQuery.isEmpty ||
          place.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          place.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
          place.category.toLowerCase().contains(searchQuery.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: CustomScrollView(
              slivers: [
                // HEADER
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'WanderPlan',
                              style: TextStyle(
                                color: AppTheme.deepTeal,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: AppTheme.terracotta,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${widget.appState.destination} · ${widget.appState.tripDays} ${widget.appState.tripDays == 1 ? 'Day' : 'Days'}',
                                  style: const TextStyle(
                                    color: AppTheme.mutedGrey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.sage.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.travel_explore,
                            color: AppTheme.deepTeal,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // HERO BANNER
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            _getDestinationHeroImage(widget.appState.destination),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.deepTeal,
                                child: const Center(
                                  child: Icon(Icons.landscape, size: 50, color: Colors.white70),
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
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.75),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 22,
                            right: 22,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.terracotta,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${widget.appState.tripDays}-DAY GUIDE',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Wander through\n${widget.appState.destination}.',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    height: 1.1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // SEARCH
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search places, landmarks, heritage...',
                        prefixIcon: const Icon(Icons.search, color: AppTheme.deepTeal),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    searchQuery = '';
                                  });
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // CATEGORY FILTERS
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _categoryChip('All'),
                          _categoryChip('Heritage'),
                          _categoryChip('Scenic'),
                          _categoryChip('Nature'),
                          _categoryChip('Historical'),
                          _categoryChip('Culture'),
                        ],
                      ),
                    ),
                  ),
                ),

                // SECTION TITLE & COUNT
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 14),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Places to explore',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.charcoal,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${places.length} ${places.length == 1 ? 'place' : 'places'}',
                            style: const TextStyle(
                              color: AppTheme.mutedGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // PLACES LIST OR EMPTY STATE
                if (places.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppTheme.sage.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search_off_rounded,
                                size: 34,
                                color: AppTheme.deepTeal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No places found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.charcoal,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try adjusting your search query or category filter.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.mutedGrey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 18),
                            OutlinedButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                  selectedCategory = 'All';
                                });
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Reset filters'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.deepTeal,
                                side: const BorderSide(color: AppTheme.deepTeal),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.separated(
                      itemCount: places.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final attraction = places[index];

                        return AttractionCard(
                          attraction: attraction,
                          isSaved: widget.appState.isSaved(attraction),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.detail,
                              arguments: attraction,
                            );
                          },
                          onSave: () {
                            widget.appState.toggleSaved(attraction);
                          },
                        );
                      },
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(String label) {
    final selected = selectedCategory == label;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          setState(() {
            selectedCategory = label;
          });
        },
        selectedColor: AppTheme.deepTeal,
        backgroundColor: Colors.white,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: selected ? AppTheme.deepTeal : AppTheme.sage.withValues(alpha: 0.3),
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.charcoal,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}