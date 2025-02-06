import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app_prokit/model/FoodModel.dart';
import 'package:food_app_prokit/screen/FoodCreateOtp.dart';
import 'package:food_app_prokit/utils/FoodColors.dart';
import 'package:food_app_prokit/utils/FoodDataGenerator.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:food_app_prokit/utils/FoodWidget.dart';
import 'package:nb_utils/nb_utils.dart';

class FoodCreateAccount extends StatefulWidget {
  static String tag = '/FoodCreateAccount';

  @override
  FoodCreateAccountState createState() => FoodCreateAccountState();
}

class FoodCreateAccountState extends State<FoodCreateAccount> {
  TextEditingController _signNumberController = TextEditingController();
  late List<images> mList;

  @override
  void initState() {
    super.initState();
    mList = addUserPhotosData();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width,
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    finish(context);
                  },
                ),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food_lbl_create_your_account_and_nget_99_money, style: boldTextStyle(size: 24), maxLines: 2),
                  Text(food_lbl_its_s_super_quick, style: primaryTextStyle()),
                ],
              ).paddingOnly(left: 16, right: 16),
              SizedBox(height: 30.0),
              SizedBox(
                height: width * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 16),
                      child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(mList[index].image), radius: 45),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Container(
                margin: EdgeInsets.all(16),
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
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: food_colorPrimary)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _signNumberController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          isDense: true,
                          hintText: food_hint_mobile_no,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          if (_signNumberController.text.isEmpty || _signNumberController.text.length < 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please enter a valid phone number")),
                            );
                            return;
                          }
                          FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: _signNumberController.text.trim(),
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException ex) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Verification failed: ${ex.message}")),
                              );
                            },
                            codeSent: (String verification, int? resendToken) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Foodcreateotp(
                                    verificationId: verification,
                                  ),
                                ),
                              );
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {},
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(14.0),
                          decoration: gradientBoxDecoration(
                            radius: 50,
                            gradientColor2: const Color.fromARGB(158, 228, 87, 90),
                            gradientColor1: food_colorPrimary,
                          ),
                          child: Icon(Icons.arrow_forward, color: food_white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
