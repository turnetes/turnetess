import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingWidget extends StatefulWidget{

  _MessagingWidgetState createState() => _MessagingWidgetState();

}

class _MessagingWidgetState extends State<MessagingWidget>{

  final FirebaseMessaging firebaseMessaging  = FirebaseMessaging.instance;
  late String? mtoken = "egc9PcOgSp2Hmz6EXuk1_N:APA91bEQRdDU9oQGLZyg0UqP6vP-dPSjanTlKxxwcZm_zMtE4j48obAViaHJ7xwXOYBt-vJ4Dujn1wc1MiBsEEXjpoBgY7uHICZyjJsN9nGODCiBUFWcZf2NAljji8v7siYw3FUa7SRx";
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initState()  {
    super.initState();


    requestPermission();

    loadFCM();

    listenFCM();

    //getToken();


  }

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return  Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Press"),
          onPressed: (){
            String? token;
            print("VAMOS CON EL ENVIO!!!!!!");
            sendPushMessage(mtoken!, "AVISO", "HOLAAAAA");
          },
        )
      ),
    );
    throw UnimplementedError();
  }

  void getToken() async {
    mtoken = await FirebaseMessaging.instance.getToken().toString();

  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }


  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAf0Ozhp4:APA91bFFyLD48dq9DJrn9vqgY1wC6X0rekPbE7WQMMOKQXhQURrvJCiwwqsObB5CAKMg926VD_4GiwOtfkszDMu3CKF9G5tuOvzmsX63EX1lIXOKS3t31FbtTbmQgR2BS8Eubz20hxGn',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

}