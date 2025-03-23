import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/FoodImages.dart';



final inspiredByCollectionsProvider = Provider<List<DashboardCollections>>((ref) {
  return [
    DashboardCollections("Gym Lover", food_ic_item4, "Starts from @E123"),
    DashboardCollections("Live Music", food_ic_item11, "Starts from @E123"),
    DashboardCollections("Friends", food_ic_item6, "Starts from @E123"),
    DashboardCollections("Gym Lover", food_ic_item4, "Starts from @E123")];
});


final bakeryRestaurantsProvider = Provider<List<Restaurants>>((ref) {
  return [
    Restaurants("Live Cake & Bakery Shop", 4, food_ic_popular2, "50 Reviews"),
    Restaurants("Richie Rich Cake Shop", 2, food_ic_item12, "50 Reviews"),
    Restaurants("American Dry Fruit Ice Cream", 5, food_ic_item1, "50 Reviews"),
    Restaurants("Cake & Bakery Shop", 4, food_ic_item13, "50 Reviews"),
  ];
});



final deliveryRestaurantsProvider = Provider<List<Restaurants>>((ref) {
  return [
    Restaurants("American Chinese cuisine", 4, food_ic_popular4, "50 Reviews"),
    Restaurants("Bread", 2, food_ic_popular3, "50 Reviews"),
    Restaurants("Restro Bistro", 5, food_ic_item1, "50 Reviews"),
    Restaurants("Hugs with mugs", 4, food_ic_item6, "50 Reviews"),
  ];
});

final dineOutRestaurantsProvider = Provider<List<Restaurants>>((ref) {
  return [
    Restaurants("Raise The Bar \nRooftTop", 4, food_ic_item13, "50 Reviews"),
    Restaurants("Destination Restro & Cafe", 2, food_ic_item14, "50 Reviews"),
    Restaurants("Apple Dine", 5, food_ic_item15, "50 Reviews"),
  ];
});

final cafeRestaurantsProvider = Provider<List<Restaurants>>((ref) {
  return [
    Restaurants("Domesticated turkey", 4, food_ic_item2, "50 Reviews"),
    Restaurants("Germen Chocolate Cake", 2, food_ic_item6, "50 Reviews"),
    Restaurants("Tihar", 5, food_ic_item10, "50 Reviews"),
    Restaurants("Cafe klatch", 5, food_ic_item1, "50 Reviews"),
  ];
});

final cuisineCollectionProvider = Provider<List<DashboardCollections>>((ref) {
  return [
    DashboardCollections("Italian", food_ic_item6, "100+ Experience"),
    DashboardCollections("Goan", food_ic_item4, "50+ Experience"),
    DashboardCollections("Chines", food_ic_item11, "20+ Experience"),
    DashboardCollections("Indian", food_ic_item6, "100+ Experience"),
  ];
});