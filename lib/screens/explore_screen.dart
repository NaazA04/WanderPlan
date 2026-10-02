import 'package:flutter/material.dart';

import '../main.dart';
import '../models/attraction.dart';
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
      final categoryMatch = selectedCategory == 'All' ||
          place.category.toLowerCase() == selectedCategory.toLowerCase();

      final searchMatch = searchQuery.isEmpty ||
          place.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          place.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
          place.category.toLowerCase().contains(searchQuery.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();

    // Secondary recommended places
    final recommendedPlaces = allPlaces.reversed.take(4).toList();

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: CustomScrollView(
            slivers: [
              // SCENIC HERO SECTION WITH HEADER INTEGRATION
              SliverToBoxAdapter(
                child: Container(
                  height: 340,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 18,
                        offset: Offset(0, 6),
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
                              Colors.black.withValues(alpha: 0.5),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.0, 0.35, 1.0],
                          ),
                        ),
                      ),

                      // TOP BRAND & DESTINATION
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 13,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${widget.appState.destination}, India',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // BOTTOM HERO HEADLINE
                      Positioned(
                        bottom: 24,
                        left: 22,
                        right: 22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'YOUR GUIDE · THOUGHTFULLY CURATED',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Wander through\n${widget.appState.destination}.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                height: 1.08,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Discover places, build your perfect day.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // SEARCH BAR
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search places, landmarks, experiences...',
                        hintStyle: const TextStyle(
                          color: AppTheme.mutedGrey,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.search, color: AppTheme.deepTeal, size: 22),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: AppTheme.mutedGrey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),

              // CATEGORY CHIPS
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _categoryChip('All', icon: Icons.check),
                        _categoryChip('Heritage', icon: Icons.account_balance_outlined),
                        _categoryChip('Scenic', icon: Icons.waves_outlined),
                        _categoryChip('Nature', icon: Icons.park_outlined),
                        _categoryChip('Historical', icon: Icons.fort_outlined),
                        _categoryChip('Culture', icon: Icons.theater_comedy_outlined),
                      ],
                    ),
                  ),
                ),
              ),

              // SECTION HEADER: FEATURED PLACES
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 14),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FEATURED PLACES',
                            style: TextStyle(
                              color: AppTheme.deepTeal,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Start somewhere\nremarkable',
                            style: TextStyle(
                              fontSize: 22,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.charcoal,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${places.length} places',
                        style: const TextStyle(
                          color: AppTheme.mutedGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.sage.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_off_rounded,
                              size: 32,
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
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
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

              // SECTION: RECOMMENDED · NEARBY
              if (recommendedPlaces.isNotEmpty && searchQuery.isEmpty) ...[
                const SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, 32, 20, 14),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECOMMENDED · NEARBY',
                          style: TextStyle(
                            color: AppTheme.deepTeal,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Places worth wandering for',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.charcoal,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 170,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendedPlaces.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final item = recommendedPlaces[index];
                          return _recommendedCard(item);
                        },
                      ),
                    ),
                  ),
                ),
              ] else
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(String label, {IconData? icon}) {
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color: selected ? Colors.white : AppTheme.charcoal,
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : AppTheme.charcoal,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _recommendedCard(Attraction item) {
    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
              arguments: item,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.imageUrl,
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 90,
                        color: AppTheme.sage.withValues(alpha: 0.3),
                        child: const Icon(Icons.image, color: AppTheme.deepTeal),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.category.toUpperCase()} · ${item.duration} HR',
                      style: const TextStyle(
                        color: AppTheme.deepTeal,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTheme.charcoal,
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
}