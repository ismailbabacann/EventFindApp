import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventfindapp/models/event.dart';

Future<List<Event1>> fetchEvents() async {
  const String apiUrl =
      'https://api.predicthq.com/v1/events?country=TR&location_around.origin=36.8951,30.7126&location_around.offset=100km&location_around.scale=100km';
  const String apiToken = 'ynZDyr3WJcxH6Edx_6SK-1EPvecofDoGfVCKU4fc';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Authorization': 'Bearer $apiToken'},
  );

  if (response.statusCode == 200) {
    var data =  json.decode(utf8.decode(response.bodyBytes));
    return (data['results'] as List)
        .map((e) => Event1.fromJson(e))
        .toList();
  } else {
    throw Exception('Failed to load events');
  }
}
