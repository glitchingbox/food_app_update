import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String review;
  final int selectedRating;
  final List<String> selectedTags;
  final Timestamp timestamp;

  ReviewModel({
    required this.review,
    required this.selectedRating,
    required this.selectedTags,
    required this.timestamp,
  });

factory ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  
  if (data == null) {
    return ReviewModel(
      review: '',
      selectedRating: 0,
      selectedTags: [],
      timestamp: Timestamp.now(),
    ); 
  }

  return ReviewModel(
    review: data['review'] ?? '', 
    selectedRating: data['selectedRating'] ?? 0,
    selectedTags: List<String>.from(data['selectedTags'] ?? []),
    timestamp: data['timestamp'] ?? Timestamp.now(),
  );
}

}
