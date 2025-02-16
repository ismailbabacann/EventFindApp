import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:eventfindapp/screens/feedback_page.dart';
import 'package:eventfindapp/screens/pro_page.dart';
import 'package:eventfindapp/services/savedevents_service.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:eventfindapp/widgets/custom_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapWidget extends StatefulWidget {
  final List<Event2> events2;
  final MapController mapController;

  MapWidget({
    required this.mapController,
    required this.events2,
    Key? key,
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {


  final SavedEventsService _savedEventsService = SavedEventsService();
  Position? _currentPosition;


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum servisleri kapalı, lütfen ayarlardan konumunuzu açın.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konum izni reddedildi. Ayarlardan açın.')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    widget.mapController.move(
      LatLng(position.latitude, position.longitude),
      15.0,
    );
  }


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

    Map<String, IconData> eventIcons2 = {
      'Music': Icons.music_note,
      'Undefined': Icons.camera_outlined,
      'Arts & Theatre': Icons.theater_comedy,
    };

    Map<String, String> eventBackgrounds2 = {
      'Music': 'lib/assets/icons/iconbackground_green.svg',
      'Undefined': 'lib/assets/icons/iconbackground_darkblue.svg',
      'Arts & Theatre': 'lib/assets/icons/iconbackground_purple(8A3AC8).svg',
    };

    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(36.91712494341106, 30.69958164626293),
        builder: (ctx) => CustomMarker(
          icon: Icons.workspace_premium,
          iconColor: Colors.white,
          iconSize: 20.0,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProPage()));
          },
          backgroundSvg: 'lib/assets/icons/iconbackground_cyan.svg',
        ),
      ),
    );
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(36.95108449304376, 30.771735625566283),
        builder: (ctx) => CustomMarker(
          icon: Icons.workspace_premium,
          iconColor: Colors.white,
          iconSize: 20.0,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProPage()));
          },
          backgroundSvg: 'lib/assets/icons/iconbackground_red.svg',
        ),
      ),
    );
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(36.33996972724938, 30.504978829773762),
        builder: (ctx) => CustomMarker(
          icon: Icons.workspace_premium,
          iconColor: Colors.white,
          iconSize: 20.0,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProPage()));
          },
          backgroundSvg: 'lib/assets/icons/iconbackground_darkblue.svg',
        ),
      ),
    );

    for (var event2 in widget.events2) {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
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
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 5.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onDoubleTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ProPage()),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'lib/assets/icons/group.png',
                                                height: 50,
                                                width: 100,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                '+ ? Gidiyor',
                                                style: TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
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
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Gidecek misin? Kaydet!\nEtkinlik yaklaştığında bildirim al!",
                                            style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final isSaved = await SavedEventsService().isEventSaved(event2);
                                            String title;
                                            String content;
                                            if (isSaved) {
                                              title = 'UYARI';
                                              content = 'Etkinlik zaten kayıtlı!';
                                            } else {
                                              title = 'HATIRLATMA';
                                              content = 'Kaydedilen etkinliklere eklendi! Yaklaştığında bildirim alacaksın!';
                                              await SavedEventsService().saveEvent(event2);
                                            }
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  icon: Icon(Icons.crisis_alert),
                                                  backgroundColor: Colors.white,
                                                  title: Text(title , style: TextStyle(color: mainColor),),
                                                  content: Text(content),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Tamam' , style: TextStyle(color: mainColor),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: mainColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.plus_one, color: mainColor),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20,),
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
                                              SizedBox(
                                                width: 200,
                                                child: Text(event2.location),
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  event2.address,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
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
                          Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Row(
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
                                      Icon(Icons.airplane_ticket_outlined, color: Colors.white),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          backgroundSvg: eventBackgrounds2[event2.type] ?? 'lib/assets/icons/iconbackground_red.svg',
        ),
      ));
    }
    polylines.add(
      Polyline(
        points: [
          LatLng(36.10574932855204, 32.560054744629205),
          LatLng(36.46079224539518, 32.605419861394715),
          LatLng(36.776031713819734, 32.45161126947315),
          LatLng(36.771631662712146, 32.454357851471755),
          LatLng(36.94150722996029, 32.1976984775311),
          LatLng(37.11825742257502, 32.019993877714036),
          LatLng(37.155415559442076, 32.03553089137189),
          LatLng(37.246685029913344, 31.92094541275052),
          LatLng(37.34247635035483, 31.8257811996373),
          LatLng(37.28068946224021, 31.73255911533516),
          LatLng(37.41038325814623, 31.685948073184086),
          LatLng(37.34865224594754, 31.639337031033026),
          LatLng(37.42118096040576, 31.48785114404205),
          LatLng(37.52291131036175, 31.45095073567245),
          LatLng(37.53985290457223, 31.369381411908083),
          LatLng(37.43660354881416, 31.313059735975543),
          LatLng(37.34566338125675, 30.97682050415561),
          LatLng(37.3070541647539, 30.941862222542312),
          LatLng(37.23750759583961, 30.802029096089097),
          LatLng(37.251422048064086, 30.50876795424941),
          LatLng(37.30859891402455, 30.366992694344553),
          LatLng(37.36418875724471, 30.19608553861317),
          LatLng(37.29778500067946, 30.116458341605096),
          LatLng(37.198842859603126, 29.957203947588944),
          LatLng(37.042435676560565, 29.867866113243924),
          LatLng(37.042435676560565, 29.867866113243924),
          LatLng(36.47763687204508, 29.372623786810266),
          LatLng(36.35416894187218, 29.329896998171787),
          LatLng(36.29314408579457, 29.256096180716888),
        ],
        strokeWidth: 2.0,
        color: Colors.red,
      ),
    );

    return Stack(
      children: [
        FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            center: _currentPosition != null
                ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                : LatLng(36.896951337741065, 30.688470309569553),
            zoom: 11.5,
            maxZoom: 17.0,
            minZoom: 9.5,
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
            if (_currentPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    width: 30.0,
                    height: 30.0,
                    point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    builder: (ctx) => Icon(
                      Icons.my_location,
                      color: mainColor,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: _getCurrentLocation,
            child: Icon(Icons.my_location , color: mainColor,),
          ),
        ),
        Positioned(
          bottom: 80.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
            },
            child: Icon(Icons.warning_rounded , color: mainColor,),
          ),
        ),
      ],
    );
  }
}
