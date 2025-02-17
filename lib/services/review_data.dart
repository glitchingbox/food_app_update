import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_prokit/model/FoodModel.dart';

class ReviewData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
  Future<void> addReview(String review, int selectedRating, List<String> selectedTags) async {
    try {
      await _firestore.collection('Reviews').add({
        'review': review,
        'selectedRating': selectedRating,
        'selectedTags': selectedTags,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Review added successfully!");
    } catch (e) {
      print("Firestore write error: ${e.toString()}");
    }
  }

  /// ✅ Fetch Reviews from Firestore in Real-time
  Stream<List<ReviewModel>> getReviews() {
    return _firestore.collection('Reviews')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return ReviewModel.fromFirestore(doc);
            } catch (e) {
              print("Error parsing review: $e");
              return null; // Skip faulty document
            }
          }).whereType<ReviewModel>().toList(); // ✅ Filter out null values
        });
  }
}
