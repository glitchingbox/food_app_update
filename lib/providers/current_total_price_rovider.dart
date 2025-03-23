import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import './current_cart_item_provider.dart';


final computedValueProvider = Provider.autoDispose<double>((ref) {
  // Watch the notifier's state
  final currentCartItem = ref.watch(currentCartItemsProvider);
  if(currentCartItem==null)
    {
      return 0.0;
    }
  else{
    double total = 0.0;
    for (var entry in currentCartItem.values) {
      final FoodDish foodDish = entry["item"];
      final int count = entry["count"];
      // price in fod dish is of form "\$50";
      final String price=foodDish.price;
      // Remove non-numeric characters (except the decimal point)
      String numericString = price.replaceAll(RegExp(r'[^\d.]'), '');
      // Convert to num

      total += num.parse(numericString) * count;
    }
    return total;
  }
  // Compute the desired value (e.g., double the counter value)

});