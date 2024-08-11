import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:eventfindapp/widgets/custom_marker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapWidget extends StatelessWidget {
  final List<Event2> events2;
  final MapController mapController;

  MapWidget({
    required this.mapController,
    required this.events2,
    super.key,
  });

  void _launchGoogleMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    final Uri uri = Uri.parse(url);
    if (!await launchUrlString(uri.toString(),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrlString(url.toString(),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];
    List<Polyline> polylines = [];

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
              shape: LinearBorder.top(),
              context: ctx,
              builder: (ctx) => Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (event2.imageUrl.isNotEmpty)
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Image.network(
                                    event2.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 16.0,
                                  left: 16.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,// Container'ın arka plan rengi
                                      border: Border.all(
                                        color: Colors.white, // Sınır rengi
                                        width: 5.0, // Sınır kalınlığı
                                      ),
                                      borderRadius: BorderRadius.circular(15), // Köşeleri yuvarlatmak için
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'lib/assets/icons/group.png',
                                          height: 50,
                                          width: 100,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '+23 Gidiyor',
                                          style: TextStyle(
                                            color: mainColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: () {
                                            final shareText =
                                                '*Hey EnYakından etkinlik buldum! Beraber gidelim mi?*\n\n Etkinlik: ${event2.name}\nTarih: ${event2.localDate} ${event2.localTime}\n\nMekan: ${event2.location}\nAdres: ${event2.address}\nDaha fazla bilgi: ${event2.url}';
                                            Share.share(shareText);
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
                                              Icon(Icons.share, color: Colors.white),
                                              SizedBox(width: 8),
                                              Text(
                                                'Davet et',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    SizedBox(height: 8.0),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset('lib/assets/icons/dateicon.svg'),
                                          SizedBox(width: 10),
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
                                      SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset('lib/assets/icons/locationicon.svg'),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 200,child: Expanded(child: Text(event2.location))),
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
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    SizedBox(width: 8),
                                    Text(
                                      'Yol Tarifi',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
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
                                    Icon(Icons.airplane_ticket_outlined,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Bilet Al',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
        zoom: 11.5,
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
