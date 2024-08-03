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
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Center(child: Text("NeYakın!", style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.black,
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Event1>>(
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
    );
  }
}
