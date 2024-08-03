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
              icon: const Icon(Icons.menu, color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Center(child: Text("NeYakın!", style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.black,
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
                'İsmail Babacan',
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          } else {
            var events = snapshot.data!;
            List<Marker> markers = [];
            List<Polyline> polylines = [];

            Map<String, IconData> eventIcons = {
              'school-holidays': Icons.school,
              'public-holidays': Icons.holiday_village,
              'observances': Icons.approval,
              'politics': Icons.how_to_vote,
              'conferences': Icons.account_balance,
              'expos': Icons.stadium_sharp,
              'concerts': Icons.library_music,
              'festivals': Icons.festival,
              'performing-arts': Icons.theater_comedy,
              'sports': Icons.sports_tennis,
              'community': Icons.diversity_3,
              'daylight-savings': Icons.solar_power,
              'airport-delays': Icons.connecting_airports,
              'severe-weather': Icons.cloudy_snowing,
              'disasters': Icons.volcano,
              'terror': Icons.upcoming,
              'health-warnings': Icons.curtains,
              'academic': Icons.book,
            };

            for (var event in events) {
              try {
                print('Event: $event'); // Her etkinliği kontrol etme
                var location = event['location'];
                var type = event['category'] ?? 'Unknown';

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
                      builder: (ctx) => IconButton(
                        icon: Icon(eventIcons[type] ?? Icons.account_balance),
                        color: Colors.deepPurple,
                        iconSize: 50.0,
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
                  );
                }
              } catch (e) {
                print('Error processing event: $e'); // Hata ayıklama
              }
            }

            polylines.add(
              Polyline(
                points: [
                  LatLng(36.82757500737217, 31.20382563379399),
                  LatLng(36.87755134396642, 31.175886482820044),
                  LatLng(36.951684290162035, 31.11942584286045),
                  LatLng(37.11436757852954, 30.945256277344882),
                  LatLng(37.19840982890453, 30.781750144873083),
                  LatLng(37.127593897158405, 30.579144725270357),
                  LatLng(37.022664616366825, 30.5305668192422),
                  LatLng(37.024556518371675, 30.52464268436072),
                  LatLng(36.80383317969072, 30.399051023329868),
                  LatLng(36.480186406615005, 30.520931326886657),
                ],
                strokeWidth: 2.0,
                color: Colors.red,
              ),
            );

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(36.896951337741065, 30.688470309569553), // memurevleri mahallesi konumu
                zoom: 12.2,
                maxZoom: 13.0,
                minZoom: 11.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: polylines,
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
