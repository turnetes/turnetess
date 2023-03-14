import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:turnetes/Controladores/LoginControl.dart';


class LoginResetPassVista extends StatefulWidget {

  _LoginResetPassVista createState() => _LoginResetPassVista();
}

class  _LoginResetPassVista extends State<LoginResetPassVista>{

  final TextEditingController mailController = new TextEditingController();
  final formGlobalKey = GlobalKey <FormState> ();
  bool pass1toStep2 = false;

  void initState(){
    super.initState();
    mailController.addListener(() {
      setState((){
        if (EmailValidator.validate(mailController.text)) {
          pass1toStep2 = true;
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final mailfield =TextFormField(
      autofocus: false,
      controller: mailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if(mailController!.text.isEmpty){
          return 'correo vacio';
        }
        if (!EmailValidator.validate(value!)) {
            return 'correo no valido';
          }
          return null;
        },
      onSaved: (value){
        mailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail, color: Colors.purple),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "correo", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.purple,
            title:  Text(
              'Resetear contraseña',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
        ),
        body:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: formGlobalKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                        'Reset contraseña',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: mailfield
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                        ),
                        child: Text("Reestablecer contraseña"),
                        onPressed:  pass1toStep2 ? () async {
                          if (formGlobalKey.currentState!.validate()){
                            formGlobalKey.currentState?.save();
                            LoginControl loginControl = LoginControl(context);
                            loginControl.sendMailResetPass(context,mailController.text.trim());
                          }
                        } : null
                    )
                  ],
                ),
              )
          ),
        )
    );
  }

}