import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:food_app_prokit/services/review_data.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';
import 'package:food_app_prokit/utils/FoodColors.dart';
import 'package:food_app_prokit/utils/FoodDataGenerator.dart';
import 'package:food_app_prokit/utils/FoodImages.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:food_app_prokit/utils/FoodWidget.dart';
import 'package:food_app_prokit/utils/order_online.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import 'FoodBookDetail.dart';
import 'FoodDescription.dart';
import 'FoodGallery.dart';
import 'FoodReview.dart';

class FoodRestaurantsDescription extends StatefulWidget {
  static String tag = '/FoodRestaurantsDescription';
  @override
  FoodRestaurantsDescriptionState createState() => FoodRestaurantsDescriptionState();
}

class FoodRestaurantsDescriptionState extends State<FoodRestaurantsDescription> {
  List<DataFilter> list = getAllData();
  late List<ReviewModel> mReviewList;
  late List<FoodDish> mList2;
  var mPeopleList, mCuisine;
  @override
  late TextEditingController controller;
  void initState() {
    super.initState();
    controller = TextEditingController();
    mReviewList = addReviewData();
    mList2 = orderData();

    mPeopleList = [
      "1",
      "2",
      "3",
      "4",
      "5",
    ];

    mCuisine = [
      "South Indian",
      "American",
      "BBQ",
      "Bakery",
      "Biryani",
      "Burger",
      "Cafe",
      "Charcoal Chicken",
      "Chiness",
      "Fast Food",
      "Juice",
      "Gujarati",
      "Salad",
    ];

    changeStatusColor(Colors.transparent);
  }

  Future<void> addReview(String reviewText, int rating, List<String> tags) async {
    await FirebaseFirestore.instance.collection('Reviews').add({
      'review': reviewText,
      'selectedRating': rating,
      'selectedTags': tags,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  void dispose() {
    super.dispose();
    changeStatusColor(appStore.isDarkModeOn ? Colors.black : Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.height * 0.33;
    var width = MediaQuery.of(context).size.width;
    var mTime = 0;
    Widget mOption(var icon, var value) {
      return Container(
        child: Column(
          children: <Widget>[
            Icon(icon, color: food_colorPrimary, size: 20),
            Text(
              value,
              style: primaryTextStyle(
                size: 15,
                color: Colors.black,
                weight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      );
    }

    Widget iconWithTitle(var icon, var value) {
      return RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 15,
                ),
                child: Icon(
                  icon,
                  color: food_colorPrimary,
                  size: 18,
                ),
              ),
            ),
            TextSpan(
              text: value,
              style: primaryTextStyle(
                size: 15,
                color: appStore.isDarkModeOn ? white : food_textColorPrimary,
              ),
            ),
          ],
        ),
      );
    }

    Widget mGallery(var icon, var value) {
      return RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(icon,
                      color: appStore.isDarkModeOn ? white : const Color.fromARGB(255, 255, 255, 255), size: 18)),
            ),
            TextSpan(
                text: value,
                style: primaryTextStyle(
                    size: 16,
                    weight: FontWeight.bold,
                    color: appStore.isDarkModeOn ? white : const Color.fromARGB(255, 255, 255, 255))),
          ],
        ),
      );
    }

    Widget reviewOption(var heading, var rating) {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(heading, style: primaryTextStyle(color: food_textColorSecondary)),
            Container(height: 0.5, width: width * 0.45, color: food_view_color),
            Text(rating, style: primaryTextStyle(color: food_textColorSecondary)),
          ],
        ),
      );
    }

    // ignore: missing_return
    Widget? reviewBottomSheet(
        {required BuildContext context, required TextEditingController foodDescriptionController}) {
      final ReviewData _reviewData = ReviewData();
      int selectedRating = 0;
      List<String> selectedTags = [];
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    color: appStore.isDarkModeOn ? Colors.black : Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            food_lbl_rate_your_Experience,
                            style: primaryTextStyle(color: Colors.black, weight: FontWeight.bold, size: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            children: list
                                .asMap()
                                .map(
                                  (i, e) => MapEntry(
                                    i,
                                    Tooltip(
                                      textStyle: TextStyle(fontSize: 16),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color.fromARGB(158, 228, 87, 90),
                                              food_colorPrimary,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: defaultBoxShadow()),
                                      padding: EdgeInsets.all(8),
                                      message: e.name!,
                                      child: InkWell(
                                        onTap: () {
                                          e.isCheck = !e.isCheck;
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: e.isCheck ? food_colorPrimary : food_view_color),
                                          margin: EdgeInsets.all(4),
                                          padding: EdgeInsets.all(8),
                                          child: Text(e.name!,
                                              style: secondaryTextStyle(color: e.isCheck ? white : black),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ),
                          SizedBox(height: 16),
                          Text(
                            food_lbl_what_did_you_like,
                            style: primaryTextStyle(
                              color: Colors.black,
                              weight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: mPeopleList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mTime = index;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: mTime == index ? food_colorPrimary : food_view_color,
                                  ),
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Text(
                                    mPeopleList[index],
                                    style: primaryTextStyle(color: mTime == index ? food_white : food_textColorPrimary),
                                  ).center(),
                                ),
                              );
                            },
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 2.0,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            food_lbl_anything_else_you_want_to_add,
                            style: primaryTextStyle(
                              color: Colors.black,
                              weight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          foodEditTextStyle(
                            food_hint_description,
                            controller: foodDescriptionController,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 30),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
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
                                    const Color.fromARGB(
                                      158,
                                      228,
                                      87,
                                      90,
                                    ),
                                    food_colorPrimary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  print("Submit button clicked");

                                  String reviewText = foodDescriptionController.text.trim();
                                  int selectedRating = mTime;
                                  List<String> selectedTags = list.where((e) => e.isCheck).map((e) => e.name!).toList();

                                  if (reviewText.isNotEmpty || selectedTags.isNotEmpty) {
                                    Message.show(
                                        msg:
                                            "Submitting review: Text: $reviewText, Rating: $selectedRating, Tags: $selectedTags");

                                    await _reviewData.addReview(reviewText, selectedRating, selectedTags);

                                    Message.show(msg: "Review submitted to Firestore");
                                    foodDescriptionController.clear();
                                    Navigator.pop(context);
                                    // setState((){
                                    // foodDescriptionController.clear();
                                    // });
                                  } else {
                                    Message.show(msg: "Empty review - not submitting");
                                    Message.show(msg: "Please enter a review before submitting.");
                                  }
                                },
                                child: Text(food_lbl_submit, style: primaryTextStyle(color: white)).center(),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
      return null;
    }

    return Scaffold(
      backgroundColor: food_app_background,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: expandHeight,
              floating: true,
              iconTheme: IconThemeData(
                color: appStore.isDarkModeOn ? white : black,
              ),
              forceElevated: innerBoxIsScrolled,
              pinned: true,
              titleSpacing: 0,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              title: Container(
                height: 60,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.favorite_border,
                                color: appStore.isDarkModeOn ? white : food_textColorPrimary),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.search, color: appStore.isDarkModeOn ? white : food_textColorPrimary),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: expandHeight,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      CachedNetworkImage(
                        placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                        imageUrl: food_ic_popular4,
                        width: width,
                        fit: BoxFit.cover,
                      ),
                      GestureDetector(
                        onTap: () {
                          FoodGallery().launch(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 16, bottom: 16),
                          height: width * 0.11,
                          width: width * 0.3,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: food_colorPrimary,
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
                          ),
                          child: mGallery(Icons.image, food_lbl_photo),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            color: appStore.isDarkModeOn ? scaffoldDarkColor : white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: food_colorPrimaryDark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(food_lbl_italian,
                          style: primaryTextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0), size: 18, weight: FontWeight.bold)),
                      Text(food_lbl_gravity_spacebar,
                          style: primaryTextStyle(size: 20, color: food_colorPrimary, weight: FontWeight.bold)),
                      Row(
                        children: <Widget>[
                          Text(food_lbl_gurugram_sector_19,
                              style: primaryTextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0), size: 15, weight: FontWeight.bold)),
                          Container(
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, color: const Color.fromARGB(255, 0, 0, 0)),
                            width: 4,
                            margin: EdgeInsets.only(right: 16, left: 4),
                            height: 4,
                          ),
                          Text(food_lbl_3_4_km_away,
                              style: primaryTextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0), size: 15, weight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 12),
                      totalRatting(
                        food_lbl__96_rating,
                      ),
                      SizedBox(height: 16),
                      Divider(
                        height: 0.5,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          mOption(Icons.call, food_lbl_call),
                          mOption(Icons.star_border, food_lbl_reviews),
                          mOption(Icons.add_box, food_lbl_add_photo),
                          mOption(Icons.directions, food_lbl_direction),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                FoodDescription().launch(context);
                              },
                              child: OrderOnline(),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                FoodBookDetail().launch(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: food_colorPrimary),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(food_lbl_book_table,
                                        style: primaryTextStyle(color: Colors.black, weight: FontWeight.bold, size: 18))
                                    .center(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: food_colorPrimaryDark),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(food_lbl_plan_your_visit,
                          style: primaryTextStyle(color: Colors.black, size: 18, weight: FontWeight.bold)),
                      SizedBox(height: 10),
                      iconWithTitle(Icons.hourglass_empty, food_lbl_peak_wait_up_to_30_min_from_4_00_to_10_00_pm)
                          .paddingOnly(top: 4, bottom: 4),
                      Divider(height: 0.5, color: food_view_color),
                      iconWithTitle(Icons.schedule, food_lbl_people_typically_spend_1_2_hours)
                          .paddingOnly(top: 4, bottom: 4),
                      Divider(height: 0.5, color: food_view_color),
                      iconWithTitle(
                        Icons.schedule,
                        food_lbl_you_visited_5_month_ago,
                      ).paddingOnly(
                        top: 4,
                        bottom: 4,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: food_colorPrimaryDark),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        food_lbl_user_review,
                        style: primaryTextStyle(
                          color: Colors.black,
                          size: 18,
                          weight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Text(food_lbl__5_0, style: primaryTextStyle()),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              totalRatting(food_lbl_very_good),
                              Text(
                                food_lbl__1_700_reviews_on_google,
                                style: primaryTextStyle(color: food_textColorSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      reviewOption(food_lbl_cleanliness, food_lbl__5_0),
                      reviewOption(food_lbl_comfort, food_lbl__5_0),
                      reviewOption(food_lbl_location, food_lbl__5_0),
                      reviewOption(food_lbl_Facilities, food_lbl__5_0),
                      reviewOption(food_lbl_staff, food_lbl__5_0),
                      reviewOption(food_lbl_Value, food_lbl__5_0),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          reviewBottomSheet(
                            context: context,
                            foodDescriptionController: controller,
                          );
                        },
                        child: Container(
                          width: width,
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
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(food_lbl_write_a_review,
                                  style: primaryTextStyle(color: white, weight: FontWeight.bold, size: 18))
                              .center(),
                          padding: EdgeInsets.all(12),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(food_lbl_what_guest_are_saying,
                          style: primaryTextStyle(color: Colors.black, size: 18, weight: FontWeight.bold)),
                      StreamBuilder<List<ReviewModel>>(
                        stream: ReviewData().getReviews(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            print("Error fetching reviews: ${snapshot.error}");
                            return const Center(child: Text("Error loading reviews"));
                          }
                          final reviews = snapshot.data;
                          if (reviews == null || reviews.isEmpty) {
                            print("No reviews found in Firestore");
                            return const Center(
                              child: Text(
                                " Review Not Found..! ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }
                          print("Loaded ${reviews.length} reviews from Firestore");
                          return ListView.builder(
                            itemCount: reviews.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final review = reviews[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Review ID: ${review.review}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Review(
                                      model: review,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      mViewAll(
                        context,
                        food_lbl_View_All_User_reviews,
                        onTap: () {
                          FoodReview().launch(context); 
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: food_colorPrimaryDark),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16),
                      Text(
                        food_lbl_additional_detail,
                        style: primaryTextStyle(
                          color: Colors.black,
                          size: 18,
                          weight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      iconWithTitle(Icons.call, food_user_contact).paddingOnly(top: 4, bottom: 4),
                      Divider(height: 0.5, color: food_view_color),
                      iconWithTitle(Icons.location_on, food_lbl_peak_wait_up_to_30_min_from_4_00_to_10_00_pm)
                          .paddingOnly(top: 4, bottom: 4),
                      Divider(height: 0.5, color: food_view_color),
                      iconWithTitle(Icons.schedule, food_lbl_open_hours).paddingOnly(top: 4, bottom: 4),
                      Divider(height: 0.5, color: food_view_color),
                      iconWithTitle(Icons.person_outline, food_lbl__100_for_two_people_approx)
                          .paddingOnly(top: 4, bottom: 4),
                      SizedBox(height: 16),
                      Container(
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
                          borderRadius: BorderRadius.circular(20),
                          color: appStore.isDarkModeOn ? cardDarkColor : const Color.fromARGB(255, 255, 255, 255),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.shopping_basket,
                                        color: food_color_Orange,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: food_lbl_15_off,
                                    style: primaryTextStyle(
                                      size: 16,
                                      color: food_color_Orange,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              food_lbl_on_total_bill_till_may_2020,
                              style: primaryTextStyle(
                                color: Colors.black,
                                weight: FontWeight.bold,
                              ),
                               ),                                        
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 0),
                  decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: food_colorPrimaryDark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      heading(food_lbl_what_people_love_here),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: mList2.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ItemList(mList2[index], index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Review extends StatelessWidget {
  final ReviewModel model;
  Review({
    required this.model,
  });

  // Review(ReviewModel model, int pos, this.model) {

  //   this.model = model;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(
                model.image,
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(model.review),
              Row(
                children: <Widget>[
                  mRating(model.rate),
                  Text(model.duration, style: primaryTextStyle(color: food_textColorSecondary, size: 16)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
