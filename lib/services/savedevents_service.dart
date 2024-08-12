import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedEventsService {
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection('saved_events');

  Future<void> saveEvent(Map<String, dynamic> eventData) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _eventsCollection.doc(user.uid).collection('events').add(eventData);
    }
  }

  Stream<QuerySnapshot> getSavedEvents() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _eventsCollection.doc(user.uid).collection('events').snapshots();
    }
    throw Exception('User not logged in');
  }
}
