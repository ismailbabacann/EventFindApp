import 'package:eventfindapp/widgets/ratingcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:eventfindapp/widgets/custom_drawer.dart';
import 'package:eventfindapp/widgets/map_widget.dart';
import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:eventfindapp/widgets/city_boundries.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MapController _mapController = MapController();
  List<Event2> events2 = [];
  final TicketmasterService ticketmasterService = TicketmasterService();
  String selectedCity = "Antalya";

  final Map<String, LatLng> cityLocations = {
    "Trabzon": LatLng(41.00145, 39.7178),
    "Sivas": LatLng(39.7477, 37.0179),
    "Ankara": LatLng(39.9208, 32.8541),
    "Antalya": LatLng(36.8969, 30.7133),
  };

  void loadTicketmasterEvents() async {
    List<Event2> newEvents = await ticketmasterService.getEvents(selectedCity);
    setState(() {
      events2 = newEvents;
    });
    _zoomToSelectedCity();
  }

  void _zoomToSelectedCity() {
    if (cityLocations.containsKey(selectedCity)) {
      _mapController.move(cityLocations[selectedCity]!, 12.0);
    }
  }

  @override
  void initState() {
    super.initState();
    loadTicketmasterEvents();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          drawer: const CustomDrawer(),
          body: Stack(
            children: [
              Positioned.fill(
                child: events2.isNotEmpty
                    ? MapWidget(
                  events2: events2,
                  mapController: _mapController,
                  boundaries: CityBoundaries.boundaries,
                )
                    : const Center(child: CircularProgressIndicator()),
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
                    SizedBox(width: 10),
                    Center(
                      child: SvgPicture.asset(
                        'lib/assets/icons/logo_enyakın.svg',
                        height: 45.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    DropdownButton<String>(
                      style: TextStyle(color: mainColor),
                      icon: Icon(Icons.location_on , color: mainColor,) ,
                      dropdownColor: Colors.white,
                      value: selectedCity,
                      items: ["Trabzon", "Sivas", "Ankara", "Antalya"].map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCity = newValue;
                          });
                          loadTicketmasterEvents();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 70,
                left: 0.0,
                right: 0.0,
                child: events2.isNotEmpty
                    ? CarouselSliderWidget(events: events2)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
