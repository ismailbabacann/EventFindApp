import 'package:eventfindapp/widgets/ratingcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:eventfindapp/widgets/custom_drawer.dart';
import 'package:eventfindapp/widgets/map_widget.dart';
import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MapController _mapController = MapController();
  List<Event2> events2 = [];
  final TicketmasterService ticketmasterService = TicketmasterService();

  void loadTicketmasterEvents() async {
    events2 = await ticketmasterService.getEvents();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
              child: events2.isNotEmpty
                  ? MapWidget(events2: events2, mapController: _mapController)
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
                  SizedBox(width: 10,),
                  Center(
                    child: SvgPicture.asset(
                      'lib/assets/icons/logo_enyakın.svg',
                      height: 45.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 48),
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
    );
  }
}
