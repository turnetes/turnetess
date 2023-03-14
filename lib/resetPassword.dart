import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'datos.dart';
import 'login2.dart';
/*
class resetPassword extends StatefulWidget {

  _resetPassword createState() => _resetPassword();
}

class  _resetPassword extends State<resetPassword>{

  final TextEditingController mailController = new TextEditingController();
  final formGlobalKey = GlobalKey <FormState> ();

  void initState(){
    super.initState();
    mailController.addListener(() {
      setState((){});
    });
  }


  @override
  Widget build(BuildContext context) {
    final mailfield =TextFormField(
      autofocus: false,
      controller: mailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if(value!.isEmpty){
          return("Porfavor introduzca su mail");
        }
        //un mail correcto
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+[a-z]").hasMatch(value)){
          return("introduzca un correo valido");
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
                        onPressed:  mailController.text.isNotEmpty ? () async {
                          if (formGlobalKey.currentState!.validate()){
                            formGlobalKey.currentState?.save();
                            LocalStorage storage = new LocalStorage('peticiones.json');
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: mailController.text).then((value) =>
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Login2(storage,datos))));
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

 */