import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app_prokit/main.dart';
import 'package:food_app_prokit/screen/FoodDashboard.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';
import 'package:food_app_prokit/utils/FoodColors.dart';
import 'package:food_app_prokit/utils/FoodImages.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:food_app_prokit/utils/FoodWidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'FoodCreateAccount.dart';

class FoodSignIn extends StatefulWidget {
  static String tag = '/FoodSignIn';
  @override
  FoodSignInState createState() => FoodSignInState();
}

class FoodSignInState extends State<FoodSignIn> {
  Future<void> log() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Message.show(msg: 'Google sign-in successful');
    } catch (e) {
      Message.show(msg: 'Google sign-in failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Widget mOption(var color, var icon, var value, var iconColor, valueColor) {
      return InkWell(
        onTap: () {
          FoodDashboard().launch(context);
          // log();
        },
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: 16),
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: SvgPicture.asset(icon, color: iconColor, width: 18, height: 18),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: primaryTextStyle(size: 16, color: valueColor),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          CachedNetworkImage(
            placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
            imageUrl: food_ic_login,
            height: width * 0.6,
            fit: BoxFit.cover,
            width: width,
          ),
          Container(
            margin: EdgeInsets.only(top: width * 0.5),
            child: Stack(
              children: <Widget>[
                Arc(
                  arcType: ArcType.CONVEX,
                  edge: Edge.TOP,
                  height: (MediaQuery.of(context).size.width) / 10,
                  child: Container(
                    height: (MediaQuery.of(context).size.height),
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 233, 140, 1),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStore.isDarkModeOn
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Color.fromARGB(255, 233, 140, 1),
                        border: Border.all(color: Colors.white)),
                    width: width * 0.13,
                    height: width * 0.13,
                    child: Icon(Icons.arrow_forward,
                        color: appStore.isDarkModeOn ? white : const Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: width * 0.1),
                      Text(food_app_name, style: boldTextStyle(color: food_white, size: 30, weight: FontWeight.w900)),
                      SizedBox(height: width * 0.12),
                      mOption(
                          appStore.isDarkModeOn ? black : food_white,
                          food_ic_google_fill,
                          food_lbl_google,
                          appStore.isDarkModeOn ? white : food_color_red,
                          appStore.isDarkModeOn ? white : food_textColorPrimary),
                      mOption(food_colorPrimary, food_ic_fb, food_lbl_facebook, food_white, food_white),
                      SizedBox(height: width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              height: 0.5, color: food_white, width: width * 0.07, margin: EdgeInsets.only(right: 4)),
                          Text(food_lbl_or_use_your_mobile_email.toUpperCase(),
                              style: primaryTextStyle(
                                color: food_white,
                                size: 12,
                                weight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              )),
                          Container(
                              height: 0.5, color: food_white, width: width * 0.07, margin: EdgeInsets.only(left: 4)),
                        ],
                      ),
                      SizedBox(height: width * 0.07),
                      GestureDetector(
                        onTap: () {
                          FoodCreateAccount().launch(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.171),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                  offset: Offset(
                                    0,
                                    5,
                                  ),
                                ),
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(158, 228, 87, 90),
                                  food_colorPrimary,
                                ], // Change colors as needed
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              // border: Border.all(color: white),
                              borderRadius: BorderRadius.circular(50)),
                          width: width,
                          padding: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(food_lbl_continue_with_email_mobile, style: primaryTextStyle(color: food_white))
                                .center(),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
