import 'package:flutter/material.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:food_app_prokit/screen/FoodRestaurantsDescription.dart';
import 'package:food_app_prokit/services/review_data.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:food_app_prokit/utils/FoodWidget.dart';

class FoodReview extends StatefulWidget {
  static String tag = '/FoodReview';

  @override
  FoodReviewState createState() => FoodReviewState();
}

class FoodReviewState extends State<FoodReview> {
  final ReviewData _reviewData = ReviewData();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, food_lbl_reviews),
        body: StreamBuilder<List<ReviewModel>>(
          stream: _reviewData.getReviews(),
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
              itemBuilder: (context, index) {
                return Review(
                  model: reviews[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
