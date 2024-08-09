import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:eventfindapp/widgets/custom_marker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:eventfindapp/models/event.dart';
import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapWidget extends StatelessWidget {
  final List<Event1> events;
  final List<Event2> events2;
  final MapController mapController;

  MapWidget({
    required this.events,
    required this.mapController,
    super.key,
    required this.events2,
  });

  void _launchGoogleMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    final Uri uri = Uri.parse(url);
    if (!await launchUrlString(uri.toString(), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrlString(url.toString(), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];
    List<Polyline> polylines = [];

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

    Map<String, String> eventBackgrounds1 = {
      'school-holidays': 'lib/assets/icons/iconbackground_blue.svg',
      'public-holidays': 'lib/assets/icons/iconbackground_cyan.svg',
      'observances': 'lib/assets/icons/iconbackground_darkblue.svg',
      'politics': 'lib/assets/icons/iconbackground_red.svg',
      'conferences': 'lib/assets/icons/iconbackground_cyan.svg',
      'expos': 'lib/assets/icons/iconbackground_purple(8A3AC8).svg',
      'concerts': 'lib/assets/icons/iconbackground_red.svg',
      'festivals': 'lib/assets/icons/iconbackground_cyan.svg',
      'performing-arts': 'lib/assets/icons/iconbackground_blue.svg',
      'sports': 'lib/assets/icons/iconbackground_blue.svg',
      'community': 'lib/assets/icons/iconbackground_darkblue.svg',
      'daylight-savings': 'lib/assets/icons/iconbackground_blue.svg',
      'airport-delays': 'lib/assets/icons/iconbackground_green.svg',
      'severe-weather': 'lib/assets/icons/iconbackground_red.svg',
      'disasters': 'lib/assets/icons/iconbackground_purple(8A3AC8).svg',
      'terror': 'lib/assets/icons/iconbackground_cyan.svg',
      'health-warnings': 'lib/assets/icons/iconbackground_blue.svg',
      'academic': 'lib/assets/icons/iconbackground_darkblue.svg',
    };

    Map<String, IconData> eventIcons2 = {
      'Music': Icons.music_note,
      'Undefined': Icons.camera_outlined,
      'Arts & Theatre': Icons.theater_comedy,
    };

    Map<String, String> eventBackgrounds2 = {
      'Music': 'lib/assets/icons/iconbackground_green.svg',
      'Undefined': 'lib/assets/icons/iconbackground_green.svg',
      'Arts & Theatre': 'lib/assets/icons/iconbackground_purple(8A3AC8).svg',
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
              builder: (ctx) => CustomMarker(
                icon: eventIcons1[type] ?? Icons.account_balance,
                iconColor: Colors.white,
                iconSize: 25.0,
                onPressed: () {
                  showModalBottomSheet(
                    context: ctx,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(event.description),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Kapat'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                backgroundSvg: eventBackgrounds1[type] ??
                    'lib/assets/icons/iconbackground_red.svg',
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
          iconColor: Colors.white,
          iconSize: 25.0,
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.white,
              context: ctx,
              builder: (ctx) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (event2.imageUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.network(event2.imageUrl),
                        ),
                      SizedBox(height: 16.0),
                      Text(
                        event2.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        event2.type,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('lib/assets/icons/dateicon.svg'),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event2.localDate),
                                  Text(
                                    event2.localTime,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                  'lib/assets/icons/locationicon.svg'),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event2.location),
                                  SizedBox(
                                    width: 200,
                                    child: Expanded(
                                      child: Text(
                                        event2.address,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Image.asset(
                                    'lib/assets/icons/group.png',
                                    height: 50,
                                    width: 100,
                                  ),
                                ],
                              ),
                              SizedBox(width: 8),
                              Text(
                                '+23 Going',
                                style: TextStyle(
                                  color: mainColor, // Mor renk kodu
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Katılımcıları görmek için " , style: TextStyle(fontSize: 10 , color: mainColor , fontWeight: FontWeight.bold),),
                              SvgPicture.asset('lib/assets/icons/pro.svg' , height: 40, width: 40,),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _launchGoogleMaps(event2.latitude, event2.longitude);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.map_outlined, color: Colors.white),
                                SizedBox(width: 8), // İkon ile yazı arasındaki boşluk
                                Text(
                                  'Yol Tarifi',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 60,),
                          ElevatedButton(
                            onPressed: () {
                              _launchURL(event2.url);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.airplane_ticket_outlined, color: Colors.white),
                                SizedBox(width: 8), // İkon ile yazı arasındaki boşluk
                                Text(
                                  'Bilet Al',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50,),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          backgroundSvg: eventBackgrounds2[event2.type] ??
              'lib/assets/icons/iconbackground_red.svg',
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
        minZoom: 8.0,
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
