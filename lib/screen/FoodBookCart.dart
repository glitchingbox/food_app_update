import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:food_app_prokit/utils/FoodColors.dart';
import 'package:food_app_prokit/utils/FoodDataGenerator.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:food_app_prokit/utils/dotted_border.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import 'FoodAddressConfirmation.dart';
import 'FoodCoupon.dart';
import 'FoodPayment.dart';
import '../Widgets/bottom_bill_detail_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/current_total_price_rovider.dart';
import '../providers/current_cart_item_provider.dart';
import '../Widgets/add_to_cart_button.dart';
class FoodBookCart extends StatefulWidget {
  static String tag = '/BookCart';
  @override
  FoodBookCartState createState() => FoodBookCartState();
  }
class FoodBookCartState extends State<FoodBookCart> {
  late List<FoodDish> mList2;

  @override
  void initState() {
    super.initState();
    mList2 = orderData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // color: food_app_background,
              padding: EdgeInsets.all(14),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.location_on, size: 30),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(food_lbl_Sweet_home, style: primaryTextStyle()),
                            GestureDetector(
                              onTap: () {
                                FoodAddressConfirmation().launch(context);
                              },
                              child: Text(food_lbl_change, style: primaryTextStyle(color: food_colorPrimary)),
                            ),
                          ],
                        ),
                        // Text(food_lbl_address_dashboard, style: primaryTextStyle()),
                        Text(food_lbl_delivery_time_36_min, style: primaryTextStyle(size: 14, color: food_textColorSecondary)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ShowBottomBillDetail(
                gColor1: food_colorPrimary,
                gColor2:    const Color.fromARGB(158, 228, 87, 90),
                value:  food_lbl_order_now,
                onTap: () {
              FoodPayment().launch(context);
            })
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back, color: appStore.isDarkModeOn ? white : food_textColorPrimary),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(food_lbl_your_cart, style: boldTextStyle(size: 24)),
                    SizedBox(height: 16),
                    Cart(),
                    Divider(color: food_view_color, height: 0.5),
                    SizedBox(height: 8),
                    Text(food_lbl_restaurants_bill.toUpperCase(), style: boldTextStyle()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(food_lbl_sub_total, style: primaryTextStyle()),
                Consumer(// simple consumer to watch total price

                  builder: (_, WidgetRef ref, __) {

                    final total = ref.watch(computedValueProvider);
                    return Text("\$$total", style: primaryTextStyle());
                  },
                ),


                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(food_lbl_coupon_discount, style: primaryTextStyle()),
                        Text(food_lbl_70, style: primaryTextStyle(color: appStore.isDarkModeOn ? Color.fromARGB(255, 233, 140, 1) : Color.fromARGB(255, 233, 140, 1))),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(food_lbl_gst, style: primaryTextStyle()),
                        Text(food_lbl_70, style: primaryTextStyle()),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DottedBorder(
                      color: appStore.isDarkModeOn? Color.fromARGB(255, 233, 140, 1) :      food_colorPrimary,
                      strokeWidth: 1,
                      padding: EdgeInsets.all(16),
                      radius: Radius.circular(16),
                      child: ClipRRect(
                        child: Container(
                            width: width,
                            padding: EdgeInsets.all(4),
                            color: appStore.isDarkModeOn ? cardDarkColor : food_color_light_primary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(food_lbl_you_have_saved_30_on_the_bill, style: primaryTextStyle()).center(),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        FoodCoupon().launch(context);
                                      },
                                      child: Text(food_lbl_edit, style: primaryTextStyle()).center(),
                                    ))
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

// ignore: must_be_immutable
class Cart extends ConsumerWidget {


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<FoodDish> cartItemsList=[];
    final Map<String,Map<String,dynamic>>? cartItemsMap=ref.watch(currentCartItemsProvider);
    if(cartItemsMap!=null && cartItemsMap!={})
      {
        cartItemsList= cartItemsMap.values.map((entry) => entry["item"] as FoodDish).toList();
      }

   return
   cartItemsList.isEmpty?Center(child:Text("no items in cart")):
     ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount:  cartItemsList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(
                          cartItemsList[index].image,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text( cartItemsList[index].name, style: primaryTextStyle()),
                            Text( cartItemsList[index].price, style: primaryTextStyle()),
                            //text("sd",textColor: food_textColorSecondary),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
               AddToCartButton(cartItem:cartItemsList[index])
              ],
            ),
          );
        });

  }
}
