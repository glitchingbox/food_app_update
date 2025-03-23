import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/FoodColors.dart';
import '../utils/FoodString.dart';
import '../providers/current_total_price_rovider.dart';

class ShowBottomBillDetail extends ConsumerWidget {
 final Color gColor1;
 final Color gColor2;
 final String value;
  final Function onTap;
  const ShowBottomBillDetail({super.key, required this.value,required this.onTap, required this.gColor1,required this.gColor2});
  BoxDecoration gradientBoxDecoration(
      {double radius = 10,
        Color color = Colors.transparent,
        Color gradientColor2 = food_white,
        Color gradientColor1 = food_white,
        var showShadow = false}) {
    return BoxDecoration(
      gradient:
      LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [gradientColor1, gradientColor2]),
      boxShadow: showShadow
          ? [BoxShadow(color: food_ShadowColor, blurRadius: 10, spreadRadius: 2)]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  double totalValue=ref.watch( computedValueProvider);
    return Container(
      height: 100,
      decoration:
      BoxDecoration(boxShadow: defaultBoxShadow(), border: Border.all(color: white), color: food_colorPrimaryDark),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("$totalValue", style: primaryTextStyle(size: 18)),
              Text(food_lbl_view_bill_details, style: primaryTextStyle(color: food_colorPrimary)),
            ],
          ),
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
              decoration:
              gradientBoxDecoration(radius: 50, showShadow: true, gradientColor1: gColor1, gradientColor2: gColor2),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: value, style: primaryTextStyle(size: 16, color: food_white)),
                    WidgetSpan(
                      child: Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.arrow_forward, color: food_white, size: 18)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ); ;
  }
}

