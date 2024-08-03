import 'package:eventfindapp/services/ticketmaster_service.dart';
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
              builder: (ctx) => IconButton(
                icon: Icon(eventIcons[type] ?? Icons.account_balance),
                color: Colors.deepPurple,
                iconSize: 50.0,
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
          builder: (ctx) => Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.red,
              iconSize: 45.0,
              onPressed: () {
                showDialog(
                  context: ctx,
                  builder: (ctx) => AlertDialog(
                    title: Text(event2.name),
                    content: Text(event2.location),
                  ),
                );
              },
            ),
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
        maxZoom: 13.0,
        minZoom: 11.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
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
