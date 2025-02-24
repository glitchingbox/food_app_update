import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;  // Add this field
  final String review;
  final int selectedRating;
  final List<String> selectedTags;
  final Timestamp timestamp;

  ReviewModel({
    required this.id,  // Include in the constructor
    required this.review,
    required this.selectedRating,
    required this.selectedTags,
    required this.timestamp,
  });

  // Factory method to create ReviewModel from Firestore document
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ReviewModel(
      id: doc.id,  // Get Firestore document ID
      review: data['review'] ?? '',
      selectedRating: data['selectedRating'] ?? 0,
      selectedTags: List<String>.from(data['selectedTags'] ?? []),
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
