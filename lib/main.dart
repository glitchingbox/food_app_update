import 'dart:convert';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_app_prokit/firebase_options.dart';
import 'package:food_app_prokit/screen/FoodWalkThrough.dart';
import 'package:food_app_prokit/services/notification_helper.dart';
import 'package:food_app_prokit/store/AppStore.dart';
import 'package:food_app_prokit/utils/AppTheme.dart';
import 'package:food_app_prokit/utils/FoodConstants.dart';
import 'package:food_app_prokit/utils/FoodDataGenerator.dart';
import 'package:nb_utils/nb_utils.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _fireBackgroundMessaging(RemoteMessage message) async {
  if (message.notification != null) {
    print('A Notification found in background ..!');
  }
}

AppStore appStore = AppStore();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  await initialize(aLocaleLanguageList: languageList());
  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  // initialize firebase message

  await NotificationHelper.init();

  // initialize local notification helper

  await NotificationHelper.localNotificationInitialisation();

  FirebaseMessaging.onBackgroundMessage(_fireBackgroundMessaging);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Background notification tapped..!');
      navigatorKey.currentState!.pushNamed('/FoodDashboard', arguments: message);
    }
  });

  //forground

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadContent = jsonEncode(message.data);
    print('Message found in background..!');
    if (message.notification != null) {
      NotificationHelper.showLocalNotfications(
          title: message.notification!.title!, body: message.notification!.title!, payload: payloadContent);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food App${!isMobile ? ' ${platformName()}' : ''}',
        home: FoodWalkThrough(),
        theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}
