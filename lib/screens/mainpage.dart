import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final MapController _mapController = MapController();
  Future<List<dynamic>>? _events;

  @override
  void initState() {
    super.initState();
    _events = fetchEvents();
  }

  Future<List<dynamic>> fetchEvents() async {
    const String apiUrl =
        'https://api.predicthq.com/v1/events?country=TR&location_around.origin=36.8951,30.7126&location_around.offset=100km&location_around.scale=100km';
    const String apiToken = 'ynZDyr3WJcxH6Edx_6SK-1EPvecofDoGfVCKU4fc';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $apiToken'},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data['results'] ?? [];
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.account_balance_outlined),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Center(child: Text("NeYakın!")),
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Deneme',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Mesajlar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found'));
          } else {
            var events = snapshot.data!;
            List<Marker> markers = [];

            for (var event in events) {
              try {
                print('Event: $event'); // Her etkinliği kontrol etme
                var location = event['location'];
                if (location != null &&
                    location[0] != null &&
                    location[1] != null) {
                  markers.add(
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        (location[1] as num).toDouble(), // latitude
                        (location[0] as num).toDouble(), // longitude
                      ),
                      builder: (ctx) => Container(
                        child: IconButton(
                          icon: const Icon(Icons.location_on),
                          color: Colors.red,
                          iconSize: 40.0,
                          onPressed: () {
                            showDialog(
                              context: ctx,
                              builder: (context) => AlertDialog(
                                title: Text(event['title'] ?? 'Event'),
                                content: Text(
                                  event['description'] ?? 'No description available.',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Kapat'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              } catch (e) {
                print('Error processing event: $e'); // Hata ayıklama
              }
            }
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(36.8951, 30.7126), // Antalya, Turkey
                zoom: 13.0,
              ),

              children: [
                TileLayer(
                  urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
