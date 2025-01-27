import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationHelper {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize Firebase Messaging
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    print('Device Token: $token');
  }

  // Initialize Local Notifications 
  static Future localNotificationInitialisation() async {
    //android
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');




//android
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,

    );

    //permitions for android 13

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    //onTap local notification

  }

  
   static void onNotificationTap(NotificationResponse notificationResponse) {
      navigatorKey.currentState!.pushNamed("/", arguments: notificationResponse);
    }

  static Future showLocalNotfications({
    required String title,
    required String body,
    required payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channei Description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
  }
}
