import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventfindapp/services/savedevents_service.dart';

class SavedEventsPage extends StatelessWidget {
  final SavedEventsService _savedEventsService = SavedEventsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kaydedilen Etkinlikler'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _savedEventsService.getSavedEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }

          final events = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(event['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event['type']),
                    Text(event['location']),
                    Text('${event['localDate']} ${event['localTime']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
