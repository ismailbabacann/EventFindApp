import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  void _showEventDetails(BuildContext context, Event2 event) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.network(event.imageUrl),
                ),
              SizedBox(height: 16.0),
              Text(
                event.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                event.type,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w200,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('lib/assets/icons/dateicon.svg'),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.localDate),
                          Text(
                            event.localTime,
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
                          Text(event.location),
                          SizedBox(
                            width: 200,
                            child: Text(
                              event.address,
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
                          color: Color(0xFF6B7AED),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Katılımcıları görmek için",
                        style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B7AED),
                            fontWeight: FontWeight.bold),
                      ),
                      SvgPicture.asset(
                        'lib/assets/icons/pro.svg',
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _launchGoogleMaps(event.latitude, event.longitude);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B7AED),
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
                  SizedBox(width: 60),
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(event.url);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B7AED),
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
              SizedBox(height: 50),
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
