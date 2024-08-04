import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:eventfindapp/widgets/custom_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:eventfindapp/models/event.dart';

class MapWidget extends StatelessWidget {
  final List<Event1> events;
  final List<Event2> events2;
  final MapController mapController;

  const MapWidget({
    required this.events,
    required this.mapController,
    super.key,
    required this.events2,
  });

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];
    List<Polyline> polylines = [];
    Color mainColor = Color(0xFF6D3B8C);

    Map<String, IconData> eventIcons1 = {
      'school-holidays': Icons.school,
      'public-holidays': Icons.holiday_village,
      'observances': Icons.approval,
      'politics': Icons.how_to_vote,
      'conferences': Icons.account_balance,
      'expos': Icons.stadium_sharp,
      'concerts': Icons.music_note,
      'festivals': Icons.festival,
      'performing-arts': Icons.theater_comedy,
      'sports': Icons.sports_tennis,
      'community': Icons.people,
      'daylight-savings': Icons.solar_power,
      'airport-delays': Icons.connecting_airports,
      'severe-weather': Icons.cloudy_snowing,
      'disasters': Icons.volcano,
      'terror': Icons.upcoming,
      'health-warnings': Icons.curtains,
      'academic': Icons.book,
    };
  /*
    Map<String, Color> eventColors1 = {
      'school-holidays': Colors.blue,
      'public-holidays': Colors.green,
      'observances': Colors.orange,
      'politics': Colors.red,
      'conferences': Colors.purple,
      'expos': Colors.yellow,
      'concerts': Colors.pink,
      'festivals': Colors.cyan,
      'performing-arts': Colors.teal,
      'sports': Colors.indigo,
      'community': Colors.amber,
      'daylight-savings': Colors.lime,
      'airport-delays': Colors.brown,
      'severe-weather': Colors.grey,
      'disasters': Colors.deepOrange,
      'terror': Colors.deepPurple,
      'health-warnings': Colors.lightGreen,
      'academic': Colors.blueGrey,
    };
*/
    Map<String, IconData> eventIcons2 = {
      'Music': Icons.music_note,
      'Undefined': Icons.camera_outlined,
      'Arts & Theatre': Icons.theater_comedy,
    };
/*
    Map<String, Color> eventColors2 = {
      'Music': Colors.deepOrangeAccent,
      'Arts & Theatre': Colors.blue,
      'Undefined': Colors.purple,
    };
*/
    for (var event in events) {
      try {
        var location = event.location;
        var type = event.category;

        if (location.isNotEmpty && location[0] != null && location[1] != null) {
          markers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(
                (location[1] as num).toDouble(), // latitude
                (location[0] as num).toDouble(), // longitude
              ),
              builder: (ctx) => CustomMarker(
                icon: eventIcons1[type] ?? Icons.account_balance,
                iconColor: //eventColors1[type] ??
                    Colors.white,
                iconSize: 25.0,
                onPressed: () {
                  showDialog(
                    context: ctx,
                    builder: (context) => AlertDialog(
                      title: Text(event.title),
                      content: Text(event.description),
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
        print('Error processing event: $e');
      }
    }

    for (var event2 in events2) {
      markers.add(Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(event2.latitude, event2.longitude),
        builder: (ctx) => CustomMarker(
          icon: eventIcons2[event2.type] ?? Icons.location_on,
          iconColor: //eventColors2[event2.type] ??
              Colors.white,
          iconSize: 25.0,
          onPressed: () {
            showDialog(
              context: ctx,
              builder: (ctx) => AlertDialog(
                title: Text(event2.name),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location: ${event2.location}'),
                    if (event2.imageUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.network(event2.imageUrl),
                      ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ));
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
      mapController: mapController,
      options: MapOptions(
        center: LatLng(36.896951337741065, 30.688470309569553),
        zoom: 12.2,
        maxZoom: 17.0,
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
}
