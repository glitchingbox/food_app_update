import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';

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
      Message.show(msg :"Review added successfully!");
    } catch (e) {
      Message.show(msg :"Firestore write error: ${e.toString()}");
    }
  }
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
              return null;
            }
          }).whereType<ReviewModel>().toList(); 
        });
  }
}
