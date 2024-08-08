import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:eventfindapp/widgets/map_widget.dart';

class CarouselSliderWidget extends StatelessWidget {
  final List<Event2> events;

   CarouselSliderWidget({required this.events, Key? key}) : super(key: key);

  Map<String, IconData> eventIcons2 = {
    'Music': Icons.music_note,
    'Undefined': Icons.camera_outlined,
    'Arts & Theatre': Icons.theater_comedy,
  };
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        height: 120,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
      items: events.map((event) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${event.localDate} - ${event.localTime}', style: const TextStyle(fontSize: 14.0 , color: Colors.blueAccent , fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 5),
                    Expanded(child: Text(event.name, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold ,),overflow: TextOverflow.clip,)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined , color: Colors.grey,),
                        Expanded(child: Text(event.location, style: const TextStyle(fontSize: 14.0 ,fontWeight: FontWeight.bold, color: Colors.grey),overflow: TextOverflow.clip)),
                      ],
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
