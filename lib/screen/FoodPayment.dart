import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app_prokit/main.dart';
import 'package:food_app_prokit/utils/FoodColors.dart';
import 'package:food_app_prokit/utils/FoodImages.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:food_app_prokit/utils/FoodWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'FoodDeliveryInfo.dart';

class FoodPayment extends StatefulWidget {
  static String tag = '/FoodPayment';

  @override
  FoodPaymentState createState() => FoodPaymentState();
}

class FoodPaymentState extends State<FoodPayment> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget mPaymentOption(var icon, var heading, var value, var valueColor) {
      return Container(
        decoration:
            BoxDecoration(boxShadow: defaultBoxShadow(), color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
        padding: EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            SvgPicture.asset(icon, width: width * 0.1, height: width * 0.1),
            SizedBox(height: 8),
            Text(heading, style: primaryTextStyle()),
            Text(value, style: primaryTextStyle(color: appStore.isDarkModeOn ? white : valueColor)),
          ],
        ),
      );
    }

    Widget mNetBankingOption(var icon, var value) {
      return Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(food_ic_fab_back,
                  width: width * 0.17, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
              Container(
                child: CachedNetworkImage(
                  placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                  imageUrl: icon,
                  width: width * 0.08,
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
          SizedBox(height: 4),
          Text(value, style: primaryTextStyle())
        ],
      );
    }

    return Scaffold(
      // backgroundColor: food_app_background,
      bottomNavigationBar: bottomBillDetail(
          context, food_colorPrimary, const Color.fromARGB(158, 228, 87, 90), food_delivery_info, onTap: () {
        FoodDeliveryInfo().launch(context);
      }),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: width,
              alignment: Alignment.topLeft,
              color: appStore.isDarkModeOn ? scaffoldDarkColor : white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: defaultBoxShadow(),
                        color: const Color.fromARGB(92, 252, 186, 101),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(food_lbl_payment, style: boldTextStyle(size: 18)),
                          SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: mPaymentOption(
                                      food_google_wallet, food_lbl_google_wallet, food_lbl_1799, food_color_red)),
                              SizedBox(width: 16),
                              Expanded(
                                  flex: 1,
                                  child: mPaymentOption(food_whatsapp, food_lbl_whatsapp_payment, food_lbl_connect,
                                      food_textColorPrimary)),
                            ],
                          ),
                          SizedBox(height: 0),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        boxShadow: defaultBoxShadow(),
                        color: const Color.fromARGB(92, 252, 186, 101),
                      ),
                      margin: EdgeInsets.only(top: 1, bottom: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(food_lbl_credit_cards, style: primaryTextStyle(color: Colors.black,weight: FontWeight.bold)),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: CachedNetworkImage(
                                        placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                                        imageUrl: food_ic_hdfc,
                                        height: width * 0.05,
                                        width: width * 0.05),
                                  ),
                                ),
                                TextSpan(
                                    text: food_lbl__42xx_4523_xxxx_55xx,
                                    style: primaryTextStyle(
                                        size: 16, color: appStore.isDarkModeOn ? white : food_textColorPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        boxShadow: defaultBoxShadow(),
                        color: const Color.fromARGB(92, 252, 186, 101),
                      ),
                      margin: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(food_lbl_netbanking, style: primaryTextStyle(color: Colors.black,weight: FontWeight.bold)),
                              mViewAll(context, food_lbl_view_all_banks, onTap: () {
                                //
                              }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              mNetBankingOption(food_ic_hdfc, food_lbl_hdfc),
                              mNetBankingOption(food_ic_rbs, food_lbl_rbs),
                              mNetBankingOption(food_ic_citi, food_lbl_citi),
                              mNetBankingOption(food_ic_america, food_lbl_america),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
