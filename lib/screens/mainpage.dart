import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:eventfindapp/models/event.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:eventfindapp/services/api_service.dart';
import 'package:eventfindapp/widgets/custom_drawer.dart';
import 'package:eventfindapp/widgets/map_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MapController _mapController = MapController();
  Future<List<Event1>>? _events;

  final TicketmasterService ticketmasterService = TicketmasterService();
  List<Event2> events2 = [];
   Color mainColor = Color(0xFF6D3B8C);

  void loadTicketmasterEvents() async {
    events2 = await ticketmasterService.getEvents();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _events = fetchEvents();
    loadTicketmasterEvents();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: Stack(
          children: [
            Positioned.fill(
              child: FutureBuilder<List<Event1>>(
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
                    return MapWidget(events: events, events2: events2, mapController: _mapController);
                  }
                },
              ),
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10,),
                  Center(
                    child: Image.asset(
                      'lib/assets/icons/resim_2024_08_04_181249667_photoroom.png',
                      height: 45.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
