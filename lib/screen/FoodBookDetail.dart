import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_app_prokit/services/book_table.dart';
import 'package:food_app_prokit/utils/FoodColors.dart';
import 'package:food_app_prokit/utils/FoodImages.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:food_app_prokit/utils/FoodWidget.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';


class FoodBookDetail extends StatefulWidget {
  static String tag = '/FoodBookDetail';

  @override
  FoodBookDetailState createState() => FoodBookDetailState();
}

class FoodBookDetailState extends State<FoodBookDetail> {
  int mPeople = 0;
  int mTime = 0;
  int mFood = 0;
  bool isBooking = false; // Prevent multiple taps

  List<String> mPeopleList = ["1", "2", "3", "4", "5+"];
  List<String> mFoodList = ["Veg", "Non Veg"];
  List<String> mTimeList = ["07:00", "07:30", "08:00", "08:30", "09:00", "09:15", "09:30", "10:00", "10:30", "11:00"];
  
  String formattedDate = DateFormat('dd MMM').format(DateTime.now());

  final FirestoreServiceBookTable _firestoreService = FirestoreServiceBookTable();

  Future<void> bookTable() async {
    if (isBooking) return; // Prevent multiple calls

    setState(() {
      isBooking = true;
    });

    try {
      int peopleCount = int.parse(mPeopleList[mPeople].replaceAll("+", "5"));
      String time = mTimeList[mTime];
      String foodPreference = mFoodList[mFood];

      await _firestoreService.addReservation(peopleCount, formattedDate, time, foodPreference);

      print("Reservation booked successfully!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reservation booked successfully!")),
      );
    } catch (error) {
      print("Failed to book reservation: $error");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to book reservation. Please try again.")),
      );
    } finally {
      setState(() {
        isBooking = false; // Re-enable button
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget buildOptionSelector(List<String> list, int selectedIndex, Function(int) onTap) {
      return Container(
        height: width * 0.1,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => setState(() => onTap(index)),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 16, top: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedIndex == index ? food_colorPrimary : food_colorPrimary_light,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  list[index],
                  style: primaryTextStyle(color: selectedIndex == index ? food_white : food_textColorPrimary),
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: appBar(context, food_lbl_reserve_table),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(food_dinner_table, height: width * 0.4, width: width * 0.4),
                      ),
                      SizedBox(height: 16),
                      Text(food_lbl_how_many_people, style: boldTextStyle()),
                      SizedBox(height: 4),
                      buildOptionSelector(mPeopleList, mPeople, (index) => mPeople = index),
                      SizedBox(height: 16),
                      Text(food_lbl_reservation_date, style: boldTextStyle()),
                      SizedBox(height: 4),
                      Text(formattedDate, style: primaryTextStyle()),
                      SizedBox(height: 16),
                      Text(food_lbl_set_your_time, style: boldTextStyle()),
                      SizedBox(height: 4),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: mTimeList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => setState(() => mTime = index),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: mTime == index ? food_colorPrimary : food_colorPrimary_light,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                mTimeList[index],
                                style: primaryTextStyle(color: mTime == index ? food_white : food_textColorPrimary),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      Text(food_lbl_any_food_preference, style: boldTextStyle()),
                      SizedBox(height: 4),
                      buildOptionSelector(mFoodList, mFood, (index) => mFood = index),
                      SizedBox(height: 24),
                      GestureDetector(
                        onTap: isBooking ? null : bookTable,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isBooking ? Colors.grey : food_colorPrimary,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: defaultBoxShadow(),
                          ),
                          child: Center(
                            child: Text(food_lbl_book_table, style: primaryTextStyle(color: white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
