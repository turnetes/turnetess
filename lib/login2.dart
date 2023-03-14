import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:localstorage/localstorage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:turnetes/loadMapMisAcuerdos.dart';
import 'package:turnetes/loadMapMisPeticiones.dart';
import 'package:turnetes/main.dart';
import 'package:flutter/material.dart';
import 'package:turnetes/perfil2.dart';
import 'package:turnetes/peticiones4.dart';
import 'package:turnetes/probandoClickNotifications.dart';
import 'package:turnetes/registrarPaso2.dart';
import 'package:turnetes/pedirDia.dart';
import 'package:turnetes/registrarPaso1.dart';
import 'package:turnetes/resetPassword.dart';
import 'package:turnetes/screenNotification.dart';
import 'package:turnetes/secondScreen.dart';

import 'datos.dart';
import 'main.dart';
import 'notificationApi.dart';

/*

class Login2 extends StatefulWidget{


  //final GlobalKey<NavigatorState> navtoKey = new GlobalKey<NavigatorState>();
  late LocalStorage storage;
  Datos datos;
  _Login2 createState() => _Login2();

  Login2(this.storage, this.datos);
}

class _Login2 extends State<Login2>{





  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool? isChecked = false;

  void initState()  {
    // TODO: implement initState
    super.initState();
    //LocalStorage storageLogin = new LocalStorage('login.json');
    cargarUsuario();

    LocalStorage storage = new LocalStorage('peticiones.json');
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      final notification = event.notification;
      print("SETNOTIFICATIONShowInForegroundHandler");
      event.complete(event.notification);
      print(notification.title);
      print(notification.body);
      print(notification.additionalData);
      int numMensaje = notification.additionalData!["en"];
      print("EL NUMERO ES @@@@@@@@@@@@= " + numMensaje.toString());
      /*
      if(notification.additionalData!["en"] == 5){
        print("Entra por el 5");
        int imprimirNum = notification.additionalData!["en"];
        /*
        setState((){
          navigatorKey7.currentState!.push(
            MaterialPageRoute(
                builder: (context) => ProbandoClickNotifications(imprimirNum)),
          );
        });

         */
          navigatorKey7.currentState!.push(
            MaterialPageRoute(
                builder: (context) => ScreenNotifcation()),
          );

      }
      else{
        navigatorKey7.currentState!.push(
          MaterialPageRoute(
              builder: (context) => ScreenNotifcation()),
        );
      }

       */

      /* FUNCIONABA
      if(notification.title.toString() == "PETICION DE TURNO") {
        print("Entra por aquiii. Genial");
        navigatorKey7.currentState!.push(
          MaterialPageRoute(
              builder: (context) => ScreenNotifcation()),
        );

      }


       */

      switch(numMensaje) {
        case 1: {
          // Peticion comun
          print("SE METE POR EL 1  " );
              navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => Peticiones4(storage)));

        }
        break;

        case 2: {
          //Ya tienes candidato le enviamos a MisPeticiones para k lo confirmes
          print("SE METE POR EL 2  " );
          navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => LoadMapMisPeticiones()));

        }
        break;

        case 3: {
          //Ya tienes candidato le enviamos a MisPeticiones para k lo confirmes
          print("SE METE POR EL 3  " );
          navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => LoadMapMisAcuerdos()));

        }
        break;

        case 4: {
          //Se acabo de anular el turno y el maquinista recibe mensaje de que no hace/le realizan el turno
          print("SE METE POR EL 4  " );
          navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => LoadMapMisAcuerdos()));

        }
        break;

        default: {
          navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => Perfil2()));

        }
        break;
      }

      /*


      if(notification.additionalData!["en"] == 5){
        print("Entra por el 5");
        int imprimirNum = notification.additionalData!["en"];
        navigatorKey7.currentState!.push(
          MaterialPageRoute(
              builder: (context) => Peticiones4(storage)),
        );

      }

       */


    });


    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed. C
      final notification = result.notification;
      print("SETNOTIFICATIONOPENHANDLER1");
      print(notification.title);
      print(notification.body);
      print(notification.additionalData);
      print("SETNOTIFICATIONOPENHANDLER2");
      int numMensaje = notification.additionalData!["en"];
      print("EL NUMERO ES @@@@@@@@@@@@= " + numMensaje.toString());
      /*

      if(notification.additionalData!["en"] == 5){
        print("Entra por el 5");
        int imprimirNum = notification.additionalData!["en"];
        navigatorKey7.currentState!.push(
            MaterialPageRoute(
                builder: (context) => ProbandoClickNotifications(imprimirNum)),
          );

      }
      else{
        navigatorKey7.currentState!.push(
          MaterialPageRoute(
              builder: (context) => ScreenNotifcation()),
        );
      }

       */

      switch(numMensaje) {
        case 1: {
          // Peticion comun
          print("SE METE POR EL 1  " );
          navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => Peticiones4(storage)));

        }
        break;

        case 2: {
          //Ya tienes candidato le enviamos a MisPeticiones para k lo confirmes
          print("SE METE POR EL 2  " );
          navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => LoadMapMisPeticiones()));

        }
        break;

        case 3: {
          //Ya tienes candidato le enviamos a MisPeticiones para k lo confirmes
          print("SE METE POR EL 3  " );
          navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => LoadMapMisAcuerdos()));

        }
        break;

        default: {
          navigatorKey7.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => Perfil2()));

        }
        break;
      }


      /*
      // ESTO FUNCIONABA Y ME REDIRIGIA!
      print("SETNOTIFICATIONOPENHANDLER3");
      if(notification.title.toString() == "PETICION DE TURNO") {
        print("Entra por aquiii2. Genial!!!!!!!!!!!!!!!");
          navigatorKey7.currentState!.push(
            MaterialPageRoute(
                builder: (context) => ScreenNotifcation()),
          );


      }
      else{
        print("SETNOTIFICATIONOPENHANDLER!ELSE");
      }

       */


    });



    /*


    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      final notification = event.notification;

      print("SETNOTIFICATIONShowInForegroundHandler");
      print("OJO!!!!!!!!!!!!!!!!!!!!!!!!!!!! ALGO ESTOY LEYENDO");
      //navKey.currentState!.push(MaterialPageRoute(builder: (context) => ScreenNotifcation()));
      event.complete(event.notification);
      print(notification.title);
      print(notification.body);
      print("#. "+notification.additionalData.toString());
      print("1. "+ notification.additionalData!.keys.first);
      print("2. ");
      print("3. "+ notification.additionalData!["en"].toString()); //Asi veo el valor 5

      //print("4. "+ notification.additionalData!.values);
      /*
      if(notification.title.toString() == "PETICION DE TURNO"){
        print("Entra por aquiii. Genial");
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoadMapMisAcuerdos()));
      }
      else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ScreenNotifcation()));
      }

       */
      /*
      if(notification.additionalData!["en"] == 5){
        print("Entra por el 5");
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProbandoClickNotifications(notification.additionalData!["en"])));
      }

       */
      /*
      int num = int.parse(notification.additionalData!["en"]);
      print("PUTO NUM: " + num.toString());
      switch(num) {
        case 5:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Perfil2()));
          break;
        case 8:
          break;
      }

       */
      if(notification.title.toString() == "PETICION DE TURNO"){
        print("Entra por aquiii. Genial");
        //navtoKey.currentState!.push(MaterialPageRoute(builder: (context) => ScreenNotifcation()));
       // navigatorKey5.currentState!.push(MaterialPageRoute(builder: (context) => ScreenNotifcation()));
        //Navigator.of(context).pushNamed("secondScreen");
        //Navigator.push(context, MaterialPageRoute(builder: (context) => Peticiones4(widget.storage)));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenNotifcation()));
      }
      else {
        //No es una peticion asique vemos que otro tipo de peticion
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenNotifcation()));
        //Navigator.of(context).pushNamed("secondScreen");
        //navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ScreenNotifcation()));
      }
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      final notification = result.notification;
      print("SETNOTIFICATIONOPENHANDLER");
      print("OJO!!!!!!!!!!!!!!!!!!!!!!!!!!!! ALGO ESTOY LEYENDO");
      //navKey.currentState!.push(MaterialPageRoute(builder: (context) => ScreenNotifcation()));
      print(notification.title);
      print(notification.body);
      print("#. "+notification.additionalData.toString());
      print("1. "+ notification.additionalData!.keys.first);
      //print("2. "+ notification.additionalData!["en"]);
      //print("3. "+ notification.additionalData!["data"]);
      print("4. "+ notification.additionalData!["en"].toString());

      String? prueba = "WELCOME";
      if(notification.title.toString() == "PETICION DE TURNO"){
        print("Entra por aquiii2. Genial");
        //navigatorKey5.currentState!.push(MaterialPageRoute(builder: (context) => ScreenNotifcation()));

        //navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ScreenNotifcation()));
        //GlobalKey.key!.currentState!.pushNamedAndRemoveUntil('/login2', (route) => false);
        //Navigator.of(context).pushNamed("secondScreen");
        //Navigator.push(context, MaterialPageRoute(builder: (context) => Peticiones4(widget.storage)));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenNotifcation()));
      }
      else {
        //No es una peticion asique vemos que otro tipo de peticion
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenNotifcation()));
        //Navigator.of(context).pushNamed("secondScreen");
        //navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ScreenNotifcation()));
      }



      /*
      int num0 = int.parse(notification.additionalData!["en"].toString());
      if(num0 == 5){
        print("Entra por el 5");
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProbandoClickNotifications(5)));
      }

       */

      /*

      int num = int.parse(notification.additionalData!["en"].toString());
      print("PUTO NUM1: " + num.toString());
      int num2 = notification.additionalData!["en"];
      print("PUTO NUM2: " + num2.toString());
      if(num2 == 5){
        print("ENTRA POR AQUIIIIIIIIII: ");
        Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenNotifcation()));

      }

       */
    });

     */
  }

  Widget build(BuildContext context) {

    final emailfield =TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value){
        if(!EmailValidator.validate(value!)){
          return 'correo no valido';
        }
        return null;
      },
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "correo",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    final passwordfield =TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return 'campo vacio';
        }
        //un mail correcto
        if (value.length < 6) {
          return ("introduzca una contrasena con al menos 6 caracteres");
        }
        return null;
      },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "contrasena",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80,),
            Container(
              alignment: Alignment.center,// use aligment
              child: Image.asset(
                'assets/logo.png',
                height: 200,
                width: 450,
                fit: BoxFit.fill,
              ),
            ),
            //Image(  image: AssetImage('assets/logoPrincipal.jpg')),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
              ),
              child: Text(
                'Inicia sesión',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            emailfield,
            SizedBox(height: 64.0,),
            passwordfield,
            CheckboxListTile(
                value: isChecked,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState((){
                    isChecked = value!;
                  });
                },
                title: Text("Recordar usuario")
            ),
            SizedBox(height: 64.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrarPaso1()));
                  },
                  child: Text(
                    'Registrar usuario',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      Datos datos = Datos();

                      final user = await auth.signInWithEmailAndPassword(email: emailController.text.trim(), password: emailController.text.trim());
                      //final user = datos.getUserValido(emailController.text.trim(), emailController.text.trim());
                      if (user != null) {
                        //sacar el token de Signal, puede que se este logueando con otro dispositivo distinto al registrado, con lo cual debo registrarlo el id para notificaciones de Signal
                        final status = await OneSignal.shared.getDeviceState();
                        FirebaseFirestore.instance.collection("maquinistas").doc(user.user!.uid).set(
                            {
                              'oneSignalID':  status!.userId,
                            },SetOptions(merge: true)).then((_){
                          //showAlert();
                          showAlert15();
                        });

                        print("VIENE POR DELANTE DEL SHOWALERT!!!!!!!!!!!!!!!");

                        //Navigator.pop(context);
                        //IBA POR AQUI
                      }
                      if(isChecked!){
                        print("ENTRA POR AQUI PARA GUARDAR EL JSON!!!!!!!!!!!!!!!!!!!!!!!");
                        var user = {};
                        user["email"] = emailController.text;
                        user["password"] = passwordController.text;
                        user["rememberMe"] = true;
                        //List<String> usuario = [];
                        //usuario.add(emailController.text);
                        //usuario.add(passwordController.text);
                        //String reg = await json.encode(resBody);
                        //print("IMPRIME EL JSON" + reg);
                        await widget.storage.setItem('user', await json.encode(user));
                        print("JSON GUARDADO");
                      }
                      else{
                        print("CHEK = NULL = FALSE!!!!!!!!");
                        await widget.storage.deleteItem('user');
                      }
                    } catch (e) {
                      showAlert2();
                    }
                  },
                  child: const Text(
                    'Iniciar Sesión',
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => resetPassword()));
                  },
                  child: Text(
                    'Olvido la contraseña??',
                  ),
                ),
              ],
            )
          ],

        ),
      ),
    );
  }


  showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 1),
        );

        return AlertDialog(
          title: Text('Usuario Registrado'),
        );
      },
    );
  }

  showAlert15() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 1),
              () {
            Navigator.of(context).pop(true);
            LocalStorage storage = new LocalStorage('peticiones.json');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Peticiones4(storage),
              ),
                  (route) => false,
            );
          },
        );

        return AlertDialog(
          title: Text('AVISO'),
          content: Text('Usuario registrado'),
        );
      },
    );
  }

  showAlert2() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 5),
              () {

          },
        );

        return AlertDialog(
          title: Text('Usuario no registrado.' +
              '         Intentelo de nuevo'),
        );
      },
    );
  }

  void cargarUsuario() async{
    //LocalStorage storageLogin = new LocalStorage('login.json');
    //var str2 = widget.storageLogin.getItem('user');
    await widget.storage.ready;
    var userJson = await widget.storage.getItem('user');
    print("ANTES DEL NULL!");
    if(userJson != null){
      var usuarioRegistrado =  json.decode(userJson);
      print("USUARIO REGISTRADO VAMOSOOOOOOOSSSSSS!!!!!!!!!!!!!!!!!!!!!!!" + usuarioRegistrado.toString());
      if(usuarioRegistrado.isNotEmpty ){
        setState(() {
          isChecked = true;
          emailController.text = usuarioRegistrado["email"];
          passwordController.text = usuarioRegistrado["password"];
        });

        isChecked = true;
      }
    }
    else{
      print("USERJSON ES NULLLLLLL!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }

}

 */