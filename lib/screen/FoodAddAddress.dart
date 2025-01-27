import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';
import 'package:food_app_prokit/utils/textformfield.dart';
import 'package:random_string/random_string.dart';

class FoodAddAddress extends StatefulWidget {
  static String tag = '/FoodAddAddress';

  @override
  FoodAddAddressState createState() => FoodAddAddressState();
}

class FoodAddAddressState extends State<FoodAddAddress> {
  String? _selectedLocation = 'Home';

  TextEditingController _addressNameController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();

  void _clearControllers() {
    _addressNameController.clear();
    _pinCodeController.clear();
    _cityController.clear();
    _stateController.clear();
    _addressController.clear();
    _mobileNumberController.clear();
    setState(() {
      _selectedLocation = 'Home'; // Reset dropdown to default value
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  OutlineInputBorder _customBorder({Color color = Colors.grey}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Address')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      TextFormFieldWidget(controller: _addressNameController, hintText: 'Full Name'),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormFieldWidget(
                              controller: _pinCodeController,
                              keyboardType: TextInputType.number,
                              hintText: 'Pin Code',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormFieldWidget(
                              controller: _cityController,
                              keyboardType: TextInputType.name,
                              hintText: 'City',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormFieldWidget(
                              controller: _stateController,
                              keyboardType: TextInputType.name,
                              hintText: 'State',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedLocation,
                              items: <String>['Home', 'Work'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedLocation = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                border: _customBorder(),
                                focusedBorder: _customBorder(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormFieldWidget(
                        controller: _addressController,
                        hintText: 'Address',
                      ),
                      TextFormFieldWidget(
                        controller: _mobileNumberController,
                        keyboardType: TextInputType.phone,
                        hintText: 'Mobile Number',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width, // Set the desired width here
                          child: ElevatedButton(
                            
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue), 
                              // Background color
                            ),
                            onPressed: () {
                              // Validate fields
                              if (_addressNameController.text.isEmpty ||
                                  _pinCodeController.text.isEmpty ||
                                  _cityController.text.isEmpty ||
                                  _stateController.text.isEmpty ||
                                  _addressController.text.isEmpty ||
                                  _mobileNumberController.text.isEmpty) {
                                Message.show(msg: 'Please fill all fields!');
                                return;
                              }
                        
                              // Prepare data to save
                              Map<String, dynamic> foodMapInfo = {
                                "name": _addressNameController.text.trim(),
                                "pinCode": _pinCodeController.text.trim(),
                                "city": _cityController.text.trim(),
                                "state": _stateController.text.trim(),
                                "address": _addressController.text.trim(),
                                "mobileNumber": _mobileNumberController.text.trim(),
                                "locationType": _selectedLocation,
                              };
                        
                              // Debugging print statement
                              print('Captured Data: $foodMapInfo');
                        
                              // Generate a random ID
                              String id = randomAlphaNumeric(10);
                        
                              // Save data to Firestore
                              FirebaseFirestore.instance
                                  .collection('food') // Replace with your collection name
                                  .doc(id)
                                  .set(foodMapInfo)
                                  .then((value) {
                                Message.show(msg: 'Address Added successfully');
                                _clearControllers();
                                Navigator.of(context).pop();
                              }).catchError((error) {
                                _showMessage('Error: $error');
                                print('Firestore Error: $error');
                              });
                            },
                            child: Text('Add Address', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
