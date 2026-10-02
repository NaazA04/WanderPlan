import '../models/attraction.dart';

const List<Attraction> attractions = [
  // MUMBAI
  Attraction(
    id: 'gateway',
    name: 'Gateway of India',
    category: 'Historical',
    destination: 'Mumbai',
    description:
        'One of Mumbai\'s most iconic landmarks, the Gateway of India stands overlooking the Arabian Sea at Apollo Bunder.',
    imageUrl:
        'https://images.unsplash.com/photo-1570168007204-dfb528c6958f',
    rating: 4.6,
    duration: 1.5,
    location: 'Colaba, Mumbai',
  ),
  Attraction(
    id: 'marine-drive',
    name: 'Marine Drive',
    category: 'Scenic',
    destination: 'Mumbai',
    description:
        'Enjoy Mumbai\'s famous coastal promenade, especially beautiful around sunset when the city lights begin to appear.',
    imageUrl:
        'https://images.unsplash.com/photo-1595658658481-d53d3f999875',
    rating: 4.7,
    duration: 2.0,
    location: 'Marine Drive, Mumbai',
  ),
  Attraction(
    id: 'cst',
    name: 'Chhatrapati Shivaji Terminus',
    category: 'Heritage',
    destination: 'Mumbai',
    description:
        'A UNESCO World Heritage railway terminus known for its striking Victorian Gothic architecture and historic significance.',
    imageUrl:
        'https://images.unsplash.com/photo-1595658658481-d53d3f999875',
    rating: 4.5,
    duration: 1.0,
    location: 'Fort, Mumbai',
  ),
  Attraction(
    id: 'elephanta',
    name: 'Elephanta Caves',
    category: 'Heritage',
    destination: 'Mumbai',
    description:
        'Explore ancient rock-cut caves featuring remarkable sculptures and a fascinating glimpse into India\'s artistic heritage.',
    imageUrl:
        'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1',
    rating: 4.4,
    duration: 3.0,
    location: 'Elephanta Island',
  ),
  Attraction(
    id: 'sanjay-gandhi',
    name: 'Sanjay Gandhi National Park',
    category: 'Nature',
    destination: 'Mumbai',
    description:
        'A large green escape within Mumbai offering forest trails, wildlife experiences and peaceful natural surroundings.',
    imageUrl:
        'https://images.unsplash.com/photo-1441974231531-c6227db76b6e',
    rating: 4.5,
    duration: 3.0,
    location: 'Borivali, Mumbai',
  ),

  // GOA
  Attraction(
    id: 'baga-beach',
    name: 'Baga Beach',
    category: 'Scenic',
    destination: 'Goa',
    description:
        'One of Goa\'s most popular beaches, known for its vibrant nightlife, water sports and laid-back atmosphere.',
    imageUrl:
        'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2',
    rating: 4.5,
    duration: 3.0,
    location: 'North Goa',
  ),
  Attraction(
    id: 'basilica-bom-jesus',
    name: 'Basilica of Bom Jesus',
    category: 'Heritage',
    destination: 'Goa',
    description:
        'A UNESCO World Heritage Site housing the mortal remains of St Francis Xavier, this 16th-century baroque church is Goa\'s most famous landmark.',
    imageUrl:
        'https://images.unsplash.com/photo-1587474260584-136574528ed5',
    rating: 4.6,
    duration: 1.5,
    location: 'Old Goa',
  ),
  Attraction(
    id: 'dudhsagar-falls',
    name: 'Dudhsagar Falls',
    category: 'Nature',
    destination: 'Goa',
    description:
        'One of India\'s tallest waterfalls, Dudhsagar cascades from a height of over 300 metres through a lush forest landscape.',
    imageUrl:
        'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
    rating: 4.7,
    duration: 4.0,
    location: 'Sanguem, Goa',
  ),
  Attraction(
    id: 'fort-aguada',
    name: 'Fort Aguada',
    category: 'Historical',
    destination: 'Goa',
    description:
        'A 17th-century Portuguese fort overlooking the Arabian Sea, offering panoramic views and a glimpse into Goa\'s colonial past.',
    imageUrl:
        'https://images.unsplash.com/photo-1590123715937-8bd8bf11c52b',
    rating: 4.3,
    duration: 1.5,
    location: 'Sinquerim, North Goa',
  ),
  Attraction(
    id: 'panjim-market',
    name: 'Panjim Market',
    category: 'Culture',
    destination: 'Goa',
    description:
        'Explore the colourful streets and local market of Goa\'s capital, with its Portuguese-style houses, street food and fresh produce.',
    imageUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
    rating: 4.2,
    duration: 2.0,
    location: 'Panaji, Goa',
  ),

  // JAIPUR
  Attraction(
    id: 'amber-fort',
    name: 'Amber Fort',
    category: 'Historical',
    destination: 'Jaipur',
    description:
        'A majestic hilltop fortress built with red sandstone and marble, featuring ornate palaces and stunning views over Maota Lake.',
    imageUrl:
        'https://images.unsplash.com/photo-1477587458883-47145ed94245',
    rating: 4.7,
    duration: 3.0,
    location: 'Amer, Jaipur',
  ),
  Attraction(
    id: 'hawa-mahal',
    name: 'Hawa Mahal',
    category: 'Heritage',
    destination: 'Jaipur',
    description:
        'The Palace of Winds is an iconic five-storey pink sandstone facade with 953 small windows, designed to allow royal ladies to observe street life unseen.',
    imageUrl:
        'https://images.unsplash.com/photo-1599661046289-e31897846e41',
    rating: 4.5,
    duration: 1.0,
    location: 'Pink City, Jaipur',
  ),
  Attraction(
    id: 'city-palace',
    name: 'City Palace',
    category: 'Heritage',
    destination: 'Jaipur',
    description:
        'A stunning complex of courtyards, gardens and buildings in the heart of the old city, blending Rajput and Mughal architectural styles.',
    imageUrl:
        'https://images.unsplash.com/photo-1548013146-72479768bada',
    rating: 4.6,
    duration: 2.0,
    location: 'Old City, Jaipur',
  ),
  Attraction(
    id: 'jantar-mantar',
    name: 'Jantar Mantar',
    category: 'Historical',
    destination: 'Jaipur',
    description:
        'A UNESCO World Heritage Site containing 19 astronomical instruments built in the early 18th century, the largest stone sundial in the world is located here.',
    imageUrl:
        'https://images.unsplash.com/photo-1524492412937-b28074a5d7da',
    rating: 4.4,
    duration: 1.5,
    location: 'Old City, Jaipur',
  ),
  Attraction(
    id: 'nahargarh-fort',
    name: 'Nahargarh Fort',
    category: 'Scenic',
    destination: 'Jaipur',
    description:
        'Perched on the edge of the Aravalli hills, this fort offers breathtaking panoramic views over Jaipur, especially at sunset.',
    imageUrl:
        'https://images.unsplash.com/photo-1590760475226-60ada5127a6f',
    rating: 4.5,
    duration: 2.0,
    location: 'Nahargarh, Jaipur',
  ),
];