import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';

class ReviewData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adds a new review to Firestore.
  Future<void> addReview(String review, int selectedRating, List<String> selectedTags) async {
    try {
      // Create a new document reference
      DocumentReference docRef = await _firestore.collection('Reviews').add({
        'review': review,
        'selectedRating': selectedRating,
        'selectedTags': selectedTags,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the document with its generated ID
      await docRef.update({'id': docRef.id});

      Message.show(msg: "Review added successfully!");
    } catch (e) {
      Message.show(msg: "Firestore write error: ${e.toString()}");
    }
  }

  /// Retrieves reviews from Firestore in real-time.
  Stream<List<ReviewModel>> getReviews() {
    return _firestore
        .collection('Reviews')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Received ${snapshot.docs.length} documents from Firestore");

      return snapshot.docs
          .map((doc) {
            try {
              print("Parsing document ID: ${doc.id}");
              return ReviewModel.fromFirestore(doc);
            } catch (e, stacktrace) {
              print("Error parsing review document ID ${doc.id}: $e");
              print(stacktrace);
              return null;
            }
          })
          .whereType<ReviewModel>() // Filters out null values
          .toList();
    }).handleError((error) {
      print("Firestore stream error: $error");
      Message.show(msg: "Error loading reviews. Please try again.");
    });
  }
}
