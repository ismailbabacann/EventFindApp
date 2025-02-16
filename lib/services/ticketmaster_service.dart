import 'dart:convert';
import 'package:http/http.dart' as http;

class TicketmasterService {
  final String _apiKey = 'ORpBH8ClXjAJzs8vTZjXfy3IDCX8wv9x';

  Future<List<Event2>> getEvents(String city) async {
    final String url = 'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$_apiKey&city=$city';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['_embedded'] != null && data['_embedded']['events'] != null) {
        final List<dynamic> eventsJson = data['_embedded']['events'];
        return eventsJson.map((json) => Event2.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

}

class Event2 {
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final String type;
  final String imageUrl;
  final String localTime;
  final String localDate;
  final String genre;
  final String address;
  final String url;

  Event2({
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.imageUrl,
    required this.localTime,
    required this.localDate,
    required this.genre,
    required this.address,
    required this.url,
  });

  factory Event2.fromJson(Map<String, dynamic> json) {
    var imageUrl = (json['images'] != null && json['images'].isNotEmpty)
        ? json['images'][0]['url']
        : 'https://via.placeholder.com/150';

    var venue = json['_embedded']?['venues'] != null && json['_embedded']['venues'].isNotEmpty
        ? json['_embedded']['venues'][0]
        : {};

    var location = venue['location'] ?? {};

    return Event2(
      name: json['name'] ?? 'Unknown Name',
      location: venue['name'] ?? 'Unknown Location',
      address: venue['address']?['line1'] ?? 'Antalya, Konyaaltı',
      latitude: location['latitude'] != null
          ? double.tryParse(location['latitude']) ?? 0.0
          : 0.0,
      longitude: location['longitude'] != null
          ? double.tryParse(location['longitude']) ?? 0.0
          : 0.0,
      type: json['classifications']?[0]['segment']?['name'] ?? 'Unknown Type',
      genre: json['classifications']?[0]['genre']?['name'] ?? 'Unknown Genre',
      imageUrl: imageUrl,
      localTime: json['dates']?['start']?['localTime'] ?? 'Unknown Time',
      localDate: json['dates']?['start']?['localDate'] ?? 'Unknown Date',
      url: venue['url'] ?? 'https://www.biletix.com/search/TURKIYE/tr?category_sb=-1&date_sb=-1&city_sb=Antalya#!city_sb:Antalya',
    );
  }

}
