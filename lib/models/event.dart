class Event1 {
  final String title;
  final String description;
  final List<dynamic> location;
  final String category;

  Event1({
    required this.title,
    required this.description,
    required this.location,
    required this.category,
  });

  factory Event1.fromJson(Map<String, dynamic> json) {
    return Event1(
      title: json['title'] ?? 'No title' ,
      description: json['description'] ?? 'No description available.' ,
      location: json['location'] ?? [],
      category: json['category'] ?? 'Unknown',
    );
  }
}
