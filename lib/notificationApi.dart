import 'package:path/path.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:turnetes/secondScreen.dart';

class NotificationApi {

  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future showNotification({
    int id=0,
    String? title,
    String? body,
    String? payload,
  }) async => _notifications.show(id, title, body, await notificationDetails(), payload: payload);

  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            "channelid",
            "channel name",
            importance: Importance.max
        ),
        iOS: IOSNotificationDetails()
    );
  }

  static Future init({bool initSchedule = false}) async{
    final android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings,
    onSelectNotification: (payload) async {
      onNotifications.add(payload);
    },
    );

    //when app closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }


  }

  static Future showScheduledNotification({
    int id=0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async => _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleDate, tz.local),
      await notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );


}

