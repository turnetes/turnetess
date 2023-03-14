import 'dart:convert';
/*
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:turnetes/registrarPaso2.dart';

class RegistrarPaso1 extends StatefulWidget {

  _RegistrarPaso1 createState() => _RegistrarPaso1();

}

class _RegistrarPaso1 extends State<RegistrarPaso1>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpasswordController = new TextEditingController();
  bool pass1toStep2 = false;
  bool pass2toStep2 = false;
  bool pass3toStep2 = false;



  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        if (EmailValidator.validate(emailController.text))  {
          pass1toStep2 = true;
        }
      });
    });
    passwordController.addListener(() {
      setState(() {
        if(passwordController.text.length > 5){
          pass2toStep2 = true;
        }
      });
    });

    confirmpasswordController.addListener(() {
      setState(() {
        if(confirmpasswordController.text == passwordController.text){
          pass3toStep2 = true;
        }
      });
    });
  }


  @override
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

    final confirmpasswordfield =TextFormField(
      autofocus: false,
      controller: confirmpasswordController,
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return "Porfavor la contraseña es requerida";
        }
        //un mail correcto
        if ( passwordController.text != value) {
          return ("las contraseñas no son iguales");
        }
        return null;
      },
      onSaved: (value){
        confirmpasswordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "repetir contraseña",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple,
          title:  Text(
            'Registrar usuario',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                SizedBox(height: 80,),
                Container(
                  alignment: Alignment.center,// use aligment
                  child: Image.asset(
                    'assets/logoPrincipal.jpg',
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
                    'Paso 1/2:',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                emailfield,
                SizedBox(height: 10),
                passwordfield,
                SizedBox(height: 10),
                confirmpasswordfield,
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: (pass1toStep2 && pass2toStep2 && pass3toStep2) ? () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrarPaso2(emailController.text,passwordController.text.trim())));
                        }
                            : null ,
                        child: const Text('Registrar usuario paso 2'),
                      ),
                    ]
                ),
              ]
          ),
        ),
      ),
    );
  }



}

 */