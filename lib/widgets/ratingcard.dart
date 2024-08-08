import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:readmore/readmore.dart';

class CarouselSliderWidget extends StatelessWidget {
  final List<Event2> events;

  CarouselSliderWidget({required this.events, Key? key}) : super(key: key);

  Map<String, IconData> eventIcons2 = {
    'Music': Icons.music_note,
    'Undefined': Icons.camera_alt_outlined,
    'Arts & Theatre': Icons.theater_comedy,
  };

  Map<String, Color> eventColors = {
    'Music': Color(0xFF29D697), // Yeşil
    'Undefined': Colors.orange,
    'Arts & Theatre': Color(0xFF6B7AED), // Purple
  };

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        pauseAutoPlayOnTouch: true,
        height: 120,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
      items: events.map((event) {
        return Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
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
                          /*
                          Text(
                            '${event.localDate} - ${event.localTime}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          */
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
          },
        );
      }).toList(),
    );
  }
}
