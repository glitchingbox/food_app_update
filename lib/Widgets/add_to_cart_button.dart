import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:food_app_prokit/main.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/FoodColors.dart';
import '../utils/FoodString.dart';
import 'package:food_app_prokit/providers/current_cart_item_provider.dart';


class AddToCartButton extends ConsumerWidget {
  final FoodDish cartItem;

  AddToCartButton({required this.cartItem});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.of(context).size.width;
    Map<String,Map<String,dynamic>>? cartItems =ref.watch(currentCartItemsProvider);
    cartItems=cartItems??{};
    int count=cartItems[cartItem.name]==null?0:cartItems[cartItem.name]!["count"];// to set an initial value as cartItems[cartItem.name] will be null



    return Visibility(
      visible: cartItems.containsKey(cartItem.name)==true?true:false,//checks if the cart ha this cartitem initiall there will be {} as set for cart items
      child: Container(                                              // here uniqueness is based cartItem.name as that is the key value for  currentcartitemproviders map
        height: width * 0.08,
        alignment: Alignment.center,
        width: width * 0.23,
        decoration: BoxDecoration(
            color: appStore.isDarkModeOn ? scaffoldDarkColor : white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: food_textColorPrimary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: width * 0.08,
              height: width * 0.08,
              decoration: BoxDecoration(
                  color: food_textColorPrimary,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), topLeft: Radius.circular(4))),
              child: IconButton(
                icon: Icon(Icons.remove, color: food_white, size: 10),
                onPressed: () {

                    // if (count == 1 || count < 1) {
                    //   count = 1;
                    // } else {
                    //   count = count - 1;
                    // }
                    int count=cartItems![cartItem.name]!["count"];// increment/decrement button will only be available once an item is added so this wont result in null
                    count = count - 1;
                    ref.read(currentCartItemsProvider.notifier).updateItemCount(cartItem, count);

                },
              ),
            ),
            Text("$count",//
                style: primaryTextStyle(color: appStore.isDarkModeOn ? white : food_textColorPrimary)),
            Container(
              width: width * 0.08,
              height: width * 0.08,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: food_textColorPrimary,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(4), topRight: Radius.circular(4))),
              child: IconButton(
                icon: Icon(Icons.add, color: food_white, size: 10),
                onPressed: () {
                   int count=cartItems![cartItem.name]!["count"];
                    count = count + 1;
                    ref.read(currentCartItemsProvider.notifier).updateItemCount(cartItem, count);

                },
              ),
            ),
          ],
        ),
      ),
      replacement: GestureDetector(
        onTap: () {
          ref.read(currentCartItemsProvider.notifier).addNewItemToCart(cartItem);

        },
        child: Container(
          width: width * 0.22,
          height: width * 0.08,
          decoration:
          BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(4)),

          alignment: Alignment.center,
          child: Text(food_lbl_add, style: primaryTextStyle()).center(),
        ),
      ),
    );
  }
}
//food_textColorPrimary