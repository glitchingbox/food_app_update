import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantService {
  final CollectionReference _restaurants =
      FirebaseFirestore.instance.collection('restaurants');

  Future<void> addRestaurant(Map<String, dynamic> restaurantData) async {
    try {
      await _restaurants.add(restaurantData);
      print("Restaurant added successfully!");
    } catch (e) {
      print("Failed to add restaurant: $e");
    }
  }
}
