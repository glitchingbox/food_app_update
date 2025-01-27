import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app_prokit/screen/FoodDashboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Foodcreateotp extends StatefulWidget {
  String verificationId;
  Foodcreateotp({
    super.key,
    required this.verificationId,
  });

  @override
  State<Foodcreateotp> createState() => _FoodcreateotpState();
}

class _FoodcreateotpState extends State<Foodcreateotp> {
  TextEditingController _otpController = TextEditingController();
  String otp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter the OTP sent to your phone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            PinCodeTextField(
              controller: _otpController,
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  otp = value;
                });
              },
              onCompleted: (value) {
                print('$value');
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: Colors.blue,
                selectedColor: Colors.orange,
                inactiveColor: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
              ),
              child: TextButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: _otpController.text.toString(),
                      );

                      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FoodDashboard()),
                        );
                      });
                    } catch (ex) {
                      print(ex.toString());
                    }
                  },
                  child: Text(
                    'OTP',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
