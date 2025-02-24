import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:food_app_prokit/screen/FoodRestaurantsDescription.dart';

class Fooappdescription extends State<FoodRestaurantsDescription> {
  Stream<List<ReviewModel>> getReviews() {
    return FirebaseFirestore.instance
        .collection('Reviews')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList().cast<ReviewModel>());
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewModel>>(
      stream: getReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No reviews yet"));
        }
        List<ReviewModel> reviews = snapshot.data!;
        return ListView.builder(
          itemCount: reviews.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return reviews[index].review;
          },
        );
      },
    );
  }
}
