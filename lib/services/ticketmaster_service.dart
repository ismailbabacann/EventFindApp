import 'dart:convert';
import 'package:http/http.dart' as http;

class TicketmasterService {
  final String _apiKey = 'Sls17QfoeVelkJG2joYQ1Qb3BHv0apKJ';

  Future<List<Event2>> getEvents() async {
    final String url = 'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$_apiKey&city=Antalya';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> eventsJson = data['_embedded']['events'];
      return eventsJson.map((json) => Event2.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
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
  });

  factory Event2.fromJson(Map<String, dynamic> json) {
    // Resim URL'sini almak için önceki listedeki ilk resmi seçiyoruz aman burası önemli!!!
    var imageUrl = json['images'] != null && json['images'].isNotEmpty
        ? json['images'][0]['url']
        : '';

    return Event2(
      name: json['name'],
      location: json['_embedded']['venues'][0]['name'],
      address: json['_embedded']['venues'][0]['address']['line1'] ?? '',
      latitude: double.parse(json['_embedded']['venues'][0]['location']['latitude']),
      longitude: double.parse(json['_embedded']['venues'][0]['location']['longitude']),
      type: json['classifications'][0]['segment']['name'],
      genre: json['classifications'][0]['genre']['name'],
      imageUrl: imageUrl,
      localTime: json['dates']['start']['localTime'],
      localDate: json['dates']['start']['localDate'],

    );
  }
}

