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

import '../Controladores/PeticionesControlador.dart';
import '../datos.dart';
import '../Controladores/LoginControl.dart';
import '../main.dart';
import '../notificationApi.dart';



class LoginVista extends StatefulWidget{


  //final GlobalKey<NavigatorState> navtoKey = new GlobalKey<NavigatorState>();


  _LoginVista createState() => _LoginVista();

  LoginVista();

}

class _LoginVista extends State<LoginVista>{


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool? isChecked = false;


  void initState()  {
    // TODO: implement initState
    super.initState();
    //LocalStorage storageLogin = new LocalStorage('login.json');
    //control.cargarUsuario();

  }


  Widget build(BuildContext context) {


    final LoginControl loginControl = LoginControl(context);


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
          prefixIcon: Icon(Icons.mail, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "correo",  hintStyle: TextStyle(color: Colors.purple),
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
          prefixIcon: Icon(Icons.vpn_key, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "contrasena", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 3,color: Colors.purple)
          )
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 80,),
              Container(
                alignment: Alignment.center,// use aligment
                child: Image.asset(
                  'assets/logoNuevo.png',
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
                    color: Colors.purple,
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
                  title: Text("Recordar usuario", style: TextStyle(color: Colors.purple),)
              ),
              SizedBox(height: 64.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      loginControl.eventLaunchRegisterPage1();
                    },
                    child: Text(
                      'Registrar usuario', style: TextStyle(color: Colors.purple),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                    ),
                    onPressed: () async {
                      try {
                        loginControl.checkUser(emailController.text.trim(),passwordController.text.trim(),widget);
                        //comprobamos isChecked
                        //loginControl.eventRemeberUser(isChecked!,emailController.text,emailController.text);
                      } catch (e) {
                        //showAlert2();
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
                      loginControl.eventLaunchResetPass();
                    },
                    child: Text(
                      'Olvido la contraseña??', style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              )
            ],

          ),
        )
      ),
    );
  }

  showAlert(mensaje,BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 2),
        );

        return AlertDialog(
          title: Text(mensaje),
        );
      },
    );
  }


  /*
  showAlert15() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 1),
              () {
            //Navigator.of(context).pop(true);
            LocalStorage storage = new LocalStorage('peticiones.json');
            control.pideListaPeticiones(context);
          },
        );

        return AlertDialog(
          title: Text('AVISO'),
          content: Text('Usuario registrado'),
        );
      },
    );
  }

   */

  showAlert2() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 5),
              () {
            Navigator.pop(context);
          },
        );

        return AlertDialog(
          title: Text('Usuario no registrado.' +
              '         Intentelo de nuevo'),
        );
      },
    );
  }

  /*
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

   */

}