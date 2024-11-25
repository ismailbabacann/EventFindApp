import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventfindapp/services/ticketmaster_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedEventsService {
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection('saved_events');

  String _generateEventId(Event2 event) {
    return '${event.name}_${event.location}_${event.localDate}';
  }

  Future<bool> isEventSaved(Event2 event) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String eventId = _generateEventId(event);
      final querySnapshot = await _eventsCollection
          .doc(user.uid)
          .collection('events')
          .where('eventId', isEqualTo: eventId)
          .get();
      return querySnapshot.docs.isNotEmpty;
    }
    throw Exception('User not logged in');
  }

  Future<void> saveEvent(Event2 event) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isSaved = await isEventSaved(event);
      if (!isSaved) {
        final String eventId = _generateEventId(event);
        await _eventsCollection.doc(user.uid).collection('events').add({
          'eventId': eventId,
          'name': event.name,
          'location': event.location,
          'localDate': event.localDate,
          'localTime': event.localTime,
          'latitude': event.latitude,
          'longitude': event.longitude,
          'imageUrl': event.imageUrl,
          'url': event.url,
        });
      }
    }
  }

  Stream<QuerySnapshot> getSavedEvents() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _eventsCollection.doc(user.uid).collection('events').snapshots();
    }
    throw Exception('User not logged in');
  }

  Future<void> deleteEvent(String documentId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _eventsCollection.doc(user.uid).collection('events').doc(documentId).delete();
      } catch (e) {
        print('Error deleting event: $e');
      }
    } else {
      throw Exception('User not logged in');
    }
  }
}
