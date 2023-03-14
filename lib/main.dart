



import 'dart:convert';



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:turnetes/listadoMaquinistas3.dart';
import 'package:turnetes/Controladores/LoginControl.dart';
import 'package:turnetes/notificationApi.dart';
import 'package:turnetes/login2.dart';
import 'package:turnetes/perfil2.dart';
import 'package:turnetes/peticiones4.dart';
import 'package:turnetes/screenNotification.dart';
import 'package:turnetes/secondScreen.dart';
import 'Vistas/LoginVista.dart';
import 'datos.dart';
import 'firebase_options.dart';
import 'package:flutterfire_cli/flutterfire_cli.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'localNotification.dart';


final GlobalKey<NavigatorState> navigatorKey7 = new GlobalKey<NavigatorState>();



Future<void> main() async {









  tz.initializeTimeZones();
  final String defaultLocale = Platform.localeName;

  WidgetsFlutterBinding.ensureInitialized();





  await Firebase.initializeApp(
      name: "turnetes",
      options: DefaultFirebaseOptions.currentPlatform);
  //runApp(const MyApp());
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.disablePush(false);
  OneSignal.shared.setAppId("abaf1fcf-5ec8-4294-a71c-f99746ce3a7b");

  /*
  Future<String?> token =  FirebaseMessaging.instance.getToken();
  String? token2 = await token;
  print("VAMOS CON EL TOKEN!!!!!!  = " + token2! );

   */






// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });












  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
    // Will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
  });





  initializeDateFormatting().then((_) => runApp(MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);







  @override
  Widget build(BuildContext context) {




    LocalStorage storage = new LocalStorage('peticiones.json');
    return MaterialApp(
      navigatorKey: navigatorKey7,
      title: 'Flutter Demo',
        /*
        routes: {
          // Cuando naveguemos hacia la ruta "/second", crearemos el Widget SecondScreen
          '/Peticiones4': (context) => Peticiones4(storage),
          '/ListadoMaquinistas': (context) => ListadoMaquinistas3(),
        },

         */

      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginVista(),
    );
  }


}

