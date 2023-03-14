import 'package:path/path.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

import 'package:turnetes/secondScreen.dart';

class NotificationService {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //Singleton pattern
  static final NotificationService _notificationService = NotificationService._internal();

  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin


  //Initialization Settings for iOS devices
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );



  NotificationService.init() {
     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //Initialization Settings for Android
    if (Platform.isIOS) {
      requestIOSPermissions();
    }

  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }





}



  



