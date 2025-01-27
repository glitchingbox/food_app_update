import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Foodmessagescreen extends StatefulWidget {
  const Foodmessagescreen({super.key});

  @override
  State<Foodmessagescreen> createState() => _FoodmessagescreenState();
}

class _FoodmessagescreenState extends State<Foodmessagescreen> {

  Map payloadContent ={};
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
// background terminated state
    if(data is RemoteMessage){
      payloadContent = data.data;
    }

    //forground state

    if(data is NotificationResponse){
      // decode to json
      payloadContent = jsonDecode(data.payload!);
    }

    String firstKey = payloadContent.keys.first;
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
        
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            Text('$firstKey'),
          ],
        ),
      ),
    );
  }
}