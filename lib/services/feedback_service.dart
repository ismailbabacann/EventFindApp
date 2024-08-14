import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FeedbackService {
  final CollectionReference _feedbackCollection = FirebaseFirestore.instance.collection('feedback');

  Future<void> saveFeedback({required String feedbackType, required String feedbackDetails}) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _feedbackCollection.doc(user.uid).collection('user_feedbacks').add({
        'feedbackType': feedbackType,
        'feedbackDetails': feedbackDetails,
        'timestamp': Timestamp.now(),
      });
    } else {
      throw Exception('User not logged in');
    }
  }

  Stream<QuerySnapshot> getFeedbacks() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _feedbackCollection.doc(user.uid).collection('user_feedbacks').orderBy('timestamp', descending: true).snapshots();
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<void> deleteFeedback(String documentId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _feedbackCollection.doc(user.uid).collection('user_feedbacks').doc(documentId).delete();
      } catch (e) {
        print('Error deleting feedback: $e');
      }
    } else {
      throw Exception('User not logged in');
    }
  }
}
