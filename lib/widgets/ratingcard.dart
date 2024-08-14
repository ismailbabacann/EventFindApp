import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:eventfindapp/screens/pro_page.dart';
import 'package:eventfindapp/services/savedevents_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';

class CarouselSliderWidget extends StatelessWidget {
  final List<Event2> events;

  CarouselSliderWidget({required this.events, Key? key}) : super(key: key);

  Map<String, IconData> eventIcons2 = {
    'Music': Icons.music_note,
    'Undefined': Icons.camera_alt_outlined,
    'Arts & Theatre': Icons.theater_comedy,
  };

  Map<String, Color> eventColors = {
    'Music': Color(0xFF29D697),
    'Undefined': Colors.orange,
    'Arts & Theatre': Color(0xFF6B7AED),
  };

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

  void _showEventDetails(BuildContext context, Event2 event2) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      context: context,
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
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        pauseAutoPlayOnTouch: true,
        height: 80,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
      items: events.map((event) {
        return GestureDetector(
          onTap: () => _showEventDetails(context, event),
          child: Card(
            shadowColor: Colors.blueGrey,
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: [
                Icon(
                  eventIcons2[event.type] ?? Icons.event,
                  color: eventColors[event.type] ?? Colors.grey,
                  size: 36,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      ReadMoreText(
                        event.name,
                        trimLines: 1,
                        colorClickableText: Colors.white,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '.',
                        trimExpandedText: '.',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.black),
                          Expanded(
                            child: ReadMoreText(
                              event.location,
                              trimLines: 1,
                              colorClickableText: Colors.white,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '.',
                              trimExpandedText: '.',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
