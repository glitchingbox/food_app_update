import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_app_prokit/main.dart';
import 'package:food_app_prokit/screen/FoodAddAddress.dart';
import 'package:food_app_prokit/screen/FoodViewRestaurants.dart';
import 'package:food_app_prokit/services/auth_location_class.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'FoodColors.dart';
import 'FoodString.dart';

Widget heading(String value) {
  return Container(
    margin: EdgeInsets.all(16),
    child: Text(value.toString().toUpperCase(), style: primaryTextStyle()),
  );
}

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

Widget search(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: food_colorPrimary),
        color: context.scaffoldBackgroundColor),
    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
    child: RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
              child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.search, color: appStore.textSecondaryColor, size: 18))),
          TextSpan(
            text: food_hint_search_restaurants,
            style: TextStyle(fontSize: 16, color: appStore.textSecondaryColor),
            onEnter: (event) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodViewRestaurants(),
                  ));
            },
          ),
        ],
      ),
    ),
  );
}

String food_lbl_address_dashboard = "Fetching location...";

Future<void> _getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];
    food_lbl_address_dashboard = " ${place.locality}, ${place.country}";
  } catch (e) {
    food_lbl_address_dashboard = "Unable to get location";
  }
}

Widget mAddress(BuildContext context) {
  return Container(
    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: appStore.isDarkModeOn ? cardDarkColor : food_colorPrimary_light),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(food_lbl_address_dashboard, style: primaryTextStyle()),
        GestureDetector(
          onTap: () async {
            mChangeAddress(context);
            await _getCurrentLocation();
            (context as Element).markNeedsBuild();
          },
          child: Text(food_lbl_change, style: primaryTextStyle(color: food_colorPrimary)),
        ),
      ],
    ),
  );
}

void mChangeAddress(BuildContext context) {
  final AuthLocationClass _authLocationClass = AuthLocationClass();

  // Function to get address from lat/lng (Reverse Geocoding)
  Future<String?> _getAddressFromLatLng(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.locality}, ${place.country}"; // Example: "New York, USA"
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
    return null;
  }

  // Function to store location in Firestore
  Future<void> _getLocation(double latitude, double longitude, String? locationName) async {
    try {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': latitude,
        'longitude': longitude,
        'address': locationName ?? 'Unknown Location',
        'name': food_username,
      }, SetOptions(merge: true));

      Message.show(msg: 'Location added successfully!');
      Navigator.of(context).pop();
    } catch (e) {
      Message.show(msg: 'Error while adding location: $e');
    }
  }

  // Function to get current location
  void _getCurrentLocation() async {
    Position? position = await _authLocationClass.getCurrentLocation();
    if (position != null) {
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

      // Get location name
      String? locationName = await _getAddressFromLatLng(position.latitude, position.longitude);

      // Save to Firestore
      _getLocation(position.latitude, position.longitude, locationName);
    } else {
      print("Failed to fetch location.");
    }
  }

  // Show Bottom Sheet
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: food_white,
            ),
            height: MediaQuery.of(context).size.width * 1.0,
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(food_lbl_search_location, style: primaryTextStyle()),
                    IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon: Icon(Icons.close, color: food_textColorSecondary),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: defaultBoxShadow(spreadRadius: 3.0),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: food_white,
                      hintText: food_hint_search_restaurants,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.only(left: 26.0, bottom: 8.0, top: 8.0, right: 50.0),
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.my_location, color: food_colorPrimary, size: 18),
                        ),
                      ),
                      TextSpan(
                        text: food_lbl_use_current_location,
                        recognizer: TapGestureRecognizer()..onTap = _getCurrentLocation,
                        style: TextStyle(fontSize: 16, color: food_colorPrimary),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  color: food_view_color,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 16, bottom: 16),
                ),
                GestureDetector(
                  onTap: () {
                    FoodAddAddress().launch(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.add, color: food_colorPrimary, size: 18),
                          ),
                        ),
                        TextSpan(
                          text: food_lbl_add_address,
                          style: TextStyle(fontSize: 16, color: food_colorPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 0.5,
                  color: food_view_color,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 16, bottom: 16),
                ),
                Text(food_lbl_recent_location, style: primaryTextStyle()),
                Text(food_lbl_location, style: primaryTextStyle(color: food_textColorSecondary)),
              ],
            ),
          ),
        ),
      );
    },
  );
}

//;;;;;;;;;;;;;;;

Widget mViewAll(BuildContext context, var value, {required Function onTap}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      margin: EdgeInsets.all(16),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.arrow_forward, color: food_colorPrimary, size: 18)),
            ),
            TextSpan(text: value, style: primaryTextStyle(size: 16, color: food_colorPrimary)),
          ],
        ),
      ),
    ),
  );
}

Widget mRating(var value) {
  TextInputType? keyboardType;
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(text: value, style: primaryTextStyle(size: 14, color: food_color_green)),
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(Icons.radio_button_checked, color: food_color_green, size: 16),
          ),
        ),
      ],
    ),
  );
}

Padding foodEditTextStyle(var hintText,
    {TextInputType keyboardType = TextInputType.text, TextEditingController? controller, InputDecoration? decoration}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: TextFormField(
      keyboardType: keyboardType,
      style: primaryTextStyle(size: 14),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(24, 16, 24, 16),
        hintText: hintText,
        filled: false,
        fillColor: food_white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: food_view_color, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: food_view_color, width: 1.0),
        ),
      ),
    ),
  );
}

class Quantitybtn extends StatefulWidget {
  @override
  QuantitybtnState createState() => QuantitybtnState();
}

class QuantitybtnState extends State<Quantitybtn> {
  bool visibility = false;
  var count = 1;

  void _changed() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: visibility,
      child: Container(
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
                  setState(() {
                    if (count == 1 || count < 1) {
                      count = 1;
                    } else {
                      count = count - 1;
                    }
                  });
                },
              ),
            ),
            Text("$count", style: primaryTextStyle(color: appStore.isDarkModeOn ? white : food_textColorPrimary)),
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
                  setState(() {
                    count = count + 1;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      replacement: GestureDetector(
        onTap: () {
          _changed();
        },
        child: Container(
          width: width * 0.22,
          height: width * 0.08,
          decoration:
              BoxDecoration(border: Border.all(color: food_textColorPrimary), borderRadius: BorderRadius.circular(4)),
          alignment: Alignment.center,
          child: Text(food_lbl_add, style: primaryTextStyle()).center(),
        ),
      ),
    );
  }
}

Widget totalRatting(var value) {
  return Row(
    children: <Widget>[
      Icon(Icons.radio_button_checked, color: food_colorAccent, size: 16),
      Icon(Icons.radio_button_checked, color: food_colorAccent, size: 16),
      Icon(Icons.radio_button_checked, color: food_colorAccent, size: 16),
      Icon(Icons.radio_button_unchecked, color: food_colorAccent, size: 16),
      Icon(Icons.radio_button_unchecked, color: food_colorAccent, size: 16),
      SizedBox(width: 4),
      Text(value, style: primaryTextStyle(color: food_textColorSecondary, size: 14))
    ],
  );
}

Widget bottomBillDetail(BuildContext context, var gColor1, var gColor2, var value, {required Function onTap}) {
  return Container(
    height: 100,
    decoration:
        BoxDecoration(boxShadow: defaultBoxShadow(), border: Border.all(color: white), color: context.cardColor),
    padding: EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(food_lbl_1799, style: primaryTextStyle(size: 18)),
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
  );
}

AppBar appBar(BuildContext context, String title,
    {List<Widget>? actions, bool showBack = true, Color? color, Color? iconColor, Color? textColor}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: color ?? appStore.appBarColor,
    leading: showBack
        ? IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back, color: appStore.isDarkModeOn ? white : black),
          )
        : null,
    title: appBarTitleWidget(context, title, textColor: textColor, color: color),
    actions: actions,
  );
}

Widget appBarTitleWidget(context, String title, {Color? color, Color? textColor}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 60,
    color: color ?? appStore.appBarColor,
    child: Row(
      children: <Widget>[
        Text(
          title,
          style: boldTextStyle(color: color ?? appStore.textPrimaryColor, size: 20),
          maxLines: 1,
        ).expand(),
      ],
    ),
  );
}

void changeStatusColor(Color color) async {
  setStatusBarColor(color);
}

Widget? Function(BuildContext, String) placeholderWidgetFn() => (_, s) => placeholderWidget();

Widget placeholderWidget() => Image.asset('images/grey.jpg', fit: BoxFit.cover);
