class Attraction {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final double rating;
  final double duration;
  final String location;
  final String destination;

  const Attraction({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.duration,
    required this.location,
    required this.destination,
  });
}