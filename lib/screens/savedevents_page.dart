import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:eventfindapp/services/savedevents_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SavedEventsPage extends StatelessWidget {
  final SavedEventsService _savedEventsService = SavedEventsService();

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrlString(url.toString(), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: mainColor,
        title: Text('Kaydedilen Etkinlikler', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _savedEventsService.getSavedEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          final events = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final eventData = events[index].data() as Map<String, dynamic>?;

              if (eventData == null) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text('Etkinlik verileri mevcut değil'),
                  ),
                );
              }
              final name = eventData['name'] as String? ?? 'Bilinmiyor';
              final location = eventData['location'] as String? ?? 'Antalya, Turkey';
              final localDate = eventData['localDate'] as String? ?? 'Yakında';
              final localTime = eventData['localTime'] as String? ?? 'Saat Kesinleşmedi';
              final url = eventData['url'] as String? ?? '';
              return Dismissible(
                key: ValueKey(events[index].id),
                onDismissed: (direction) {
                  _savedEventsService.deleteEvent(events[index].id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name etkinliği silindi'),
                    ),
                  );
                },
                background: Container(color: Colors.red),
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.event, color: mainColor),
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(location, style: TextStyle(color: Colors.purpleAccent)),
                        Text('$localDate $localTime', style: TextStyle(color: Colors.pink)),
                        if (url.isNotEmpty)
                          TextButton(
                            onPressed: () => _launchURL(url),
                            child: Text('Detaylar', style: TextStyle(color: Colors.blue)),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
