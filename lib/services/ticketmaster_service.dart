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

  Event2({
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  factory Event2.fromJson(Map<String, dynamic> json) {
    return Event2(
      name: json['name'],
      location: json['_embedded']['venues'][0]['name'],
      latitude: double.parse(json['_embedded']['venues'][0]['location']['latitude']),
      longitude: double.parse(json['_embedded']['venues'][0]['location']['longitude']),
    );
  }
}
