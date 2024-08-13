import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:eventfindapp/services/savedevents_service.dart';

class SavedEventsPage extends StatelessWidget {
  final SavedEventsService _savedEventsService = SavedEventsService();

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
                return ListTile(
                  title: Text('Etkinlik verileri mevcut değil'),
                );
              }

              final name = eventData['name'] as String? ?? 'Bilinmiyor';
              final location = eventData['location'] as String? ?? 'Antalya, Turkey';
              final localDate = eventData['localDate'] as String? ?? 'Yakında';
              final localTime = eventData['localTime'] as String? ?? 'Saat Kesinleşmedi';

              return Dismissible(
                key: ValueKey(events[index].id), // Use the document ID as the key
                onDismissed: (direction) {
                  // Handle the dismissal action
                  _savedEventsService.deleteEvent(events[index].id); // Implement this method in your service

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name etkinliği silindi'),
                    ),
                  );
                },
                background: Container(color: Colors.red), // Background color when swiping
                child: ListTile(
                  leading: Icon(Icons.event, color: mainColor),
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(location, style: TextStyle(color: Colors.purpleAccent)),
                      Text('$localDate $localTime', style: TextStyle(color: Colors.pink)),
                    ],
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
