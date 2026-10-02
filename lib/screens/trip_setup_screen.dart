import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';

class TripSetupScreen extends StatefulWidget {
  final AppState appState;

  const TripSetupScreen({
    super.key,
    required this.appState,
  });

  @override
  State<TripSetupScreen> createState() => _TripSetupScreenState();
}

class _TripSetupScreenState extends State<TripSetupScreen> {
  final destinations = ['Mumbai', 'Goa', 'Jaipur'];

  late String selectedDestination;
  late int days;

  @override
  void initState() {
    super.initState();
    selectedDestination = (widget.appState.destination.isNotEmpty &&
            destinations.contains(widget.appState.destination))
        ? widget.appState.destination
        : 'Mumbai';
    days = widget.appState.tripDays > 0 ? widget.appState.tripDays : 3;
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: canPop
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.charcoal),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Change Trip',
                style: TextStyle(
                  color: AppTheme.charcoal,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 25, 24, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.deepTeal,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.deepTeal.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.explore,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Let\'s plan\nsomewhere.',
                    style: TextStyle(
                      fontSize: 38,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.charcoal,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Tell us where you are going and how long you are staying. We\'ll set up your personalized itinerary.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppTheme.mutedGrey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Where are you going?',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.charcoal,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: destinations.map((destination) {
                      final selected = destination == selectedDestination;

                      return ChoiceChip(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Text(destination),
                        ),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            selectedDestination = destination;
                          });
                        },
                        selectedColor: AppTheme.deepTeal,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: selected ? AppTheme.deepTeal : AppTheme.sage.withValues(alpha: 0.4),
                          width: 1.2,
                        ),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppTheme.charcoal,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'How many days?',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.charcoal,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trip duration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.charcoal,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '1 to 14 days (adjustable later)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.mutedGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        Row(
                          children: [
                            IconButton.filledTonal(
                              onPressed: days > 1
                                  ? () {
                                      setState(() {
                                        days--;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                              style: IconButton.styleFrom(
                                backgroundColor: AppTheme.sage.withValues(alpha: 0.2),
                                foregroundColor: AppTheme.deepTeal,
                              ),
                            ),

                            Container(
                              width: 48,
                              alignment: Alignment.center,
                              child: Text(
                                '$days',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.charcoal,
                                ),
                              ),
                            ),

                            IconButton.filledTonal(
                              onPressed: days < 14
                                  ? () {
                                      setState(() {
                                        days++;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.add),
                              style: IconButton.styleFrom(
                                backgroundColor: AppTheme.sage.withValues(alpha: 0.2),
                                foregroundColor: AppTheme.deepTeal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.sage.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.sage.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: AppTheme.deepTeal,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '$selectedDestination · $days ${days == 1 ? 'Day' : 'Days'} Trip',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppTheme.charcoal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () async {
                        await widget.appState.createTrip(
                          newDestination: selectedDestination,
                          days: days,
                        );
                        if (context.mounted) {
                          if (canPop) {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.deepTeal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        widget.appState.setupComplete ? 'Update Trip' : 'Create My Trip',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
