import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:turnetes/peticiones4.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../Controladores/LoginControl.dart';




class NewRegisterVista extends StatefulWidget{

  LoginControl loginControl;

  NewRegisterVista(this.loginControl);

  @override
  _NewRegisterVista createState() => _NewRegisterVista();

}

class  _NewRegisterVista extends State<NewRegisterVista> {

  final formGlobalKey = GlobalKey <FormState>();
  bool? isChecked = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpasswordController = new TextEditingController();
  bool pass1toStep2 = false;
  bool pass2toStep2 = false;
  bool pass3toStep2 = false;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController apodoController = new TextEditingController();
  final TextEditingController telIntController = new TextEditingController();
  final TextEditingController telExtController = new TextEditingController();
  bool activar = false;
  XFile? imageSelected;
  final ImagePicker _picker = ImagePicker();
  final picker = ImagePicker();
  File? imagen;

  @override
  Widget build(BuildContext context) {
    final emailfield = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!EmailValidator.validate(value!)) {
          return 'correo no valido';
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail,color: Colors.purple),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "correo", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    final passwordfield = TextFormField(
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
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key,color: Colors.purple),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "contrasena", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    final confirmpasswordfield = TextFormField(
      autofocus: false,
      controller: confirmpasswordController,
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return "Porfavor la contraseña es requerida";
        }
        //un mail correcto
        if (passwordController.text != value) {
          return ("las contraseñas no son iguales");
        }
        return null;
      },
      onSaved: (value) {
        confirmpasswordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key, color: Colors.purple),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "repetir contraseña", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );
    final namefield = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Porfavor introduzca su nombre");
        }
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "nombre", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );
    final apodofield = TextFormField(
      autofocus: false,
      controller: apodoController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Porfavor introduzca su apodo");
        }
      },
      onSaved: (value) {
        apodoController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle, color: Colors.purple),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "apodo", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );


    final telIntfield = TextFormField(
      autofocus: false,
      controller: telIntController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Porfavor introduzca el numero corto de renfe");
        }
        if (value.length != 6) {
          return ("El telefono interior tiene 6 cifras");
        }
      },
      onSaved: (value) {
        telIntController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone, color: Colors.purple),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "telefono interior", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );
    final telExtfield = TextFormField(
      autofocus: false,
      controller: telExtController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Porfavor introduzca su telefono personal desde el que usa la app");
        }
        if (value.length != 9) {
          return ("El telefono personal tiene 9 cifras");
        }
      },
      onSaved: (value) {
        telExtController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "telefono exterior", hintStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );
    return Scaffold(
      //backgroundColor: Color(0xFF954CFB),
      appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(
            'Registrar usuario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formGlobalKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center, // use aligment
                    child: Image.asset(
                        'assets/logoNuevo.png'),),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                  ),
                  emailfield,
                  SizedBox(height: 10),
                  passwordfield,
                  SizedBox(height: 10),
                  confirmpasswordfield,
                  SizedBox(height: 10),
                  namefield,
                  SizedBox(height: 10),
                  apodofield,
                  SizedBox(height: 10),
                  telIntfield,
                  SizedBox(height: 10),
                  telExtfield,
                  SizedBox(height: 10),
                  CheckboxListTile(
                      value: isChecked,
                      controlAffinity: ListTileControlAffinity.leading,
                      secondary: TextButton(
                          child: Text("Ver"),
                          onPressed: (){
                            widget.loginControl.launchLeyProteccionDatos();
                          }
                      ),
                      onChanged: (value) {
                        setState((){
                          isChecked = value!;
                        });
                      },
                      title: Text("Consentir ley de Proteccion Datos", style: TextStyle(color: Colors.purple),)
                  ),
                  Container(
                    child: InputDecorator(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                12.0)),
                            borderSide: BorderSide(color: Colors.purple,
                                width: 5),
                          ),
                          labelText: 'AVISO IMPORTANTE:',
                        ),
                        child:
                        Column(
                          children: [
                            Text(
                                "Es importante que pongais vuestra foto de la cara, es la unica forma de que nos conozcamos todos y saber con quien cambias el turno. Si los admins consideran que no se observa bien la foto no será registrado en la app."),
                            Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  ElevatedButton(
                                      child: Text("Seleccionar foto de perfil"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.purple, // background
                                        onPrimary: Colors.white, // foreground
                                      ),
                                      onPressed: () async {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: const Text(
                                                      'ELEGIR TIPO DE FOTO'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        child: const Text(
                                                            'Hacer foto'),
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          var pickedFile;
                                                          pickedFile =
                                                          await picker
                                                              .pickImage(
                                                              source: ImageSource
                                                                  .camera);
                                                          setState(() async {
                                                            if (pickedFile !=
                                                                null) {
                                                              imagen =
                                                              await compressFile(
                                                                  File(
                                                                      pickedFile
                                                                          .path));
                                                              //imagen = File(pickedFile.path);
                                                              if (imagen !=
                                                                  null) {
                                                                imageSelected =
                                                                null;
                                                                setState(() {});
                                                              }
                                                            }
                                                            else {
                                                              print(
                                                                  "No selecciono ninguna foto");
                                                            }
                                                          }
                                                          ); //setState();
                                                        }
                                                    ),

                                                    TextButton(
                                                        child: const Text(
                                                            'Buscar en Galería'),
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          XFile? imageSelected1 = await selectFile();
                                                          imagen =
                                                          await compressFile(
                                                              File(
                                                                  imageSelected1!
                                                                      .path));
                                                          if (imagen != null) {
                                                            imageSelected =
                                                            null;
                                                            setState(() {});
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                    )
                                                  ]
                                              ),
                                        );
                                      }
                                  ),

                                  imageSelected != null
                                      ? CircleAvatar(
                                      radius: 50, backgroundColor: Colors.white,
                                      child: Image.file(
                                          File(imageSelected!.path)))
                                      : imagen != null
                                      ? CircleAvatar(
                                      radius: 50, backgroundColor: Colors.white,
                                      child: Image.file(imagen!))
                                      : const SizedBox.shrink(),
                                ]
                            ),

                          ],
                        )
                    ),
                  ),
                  SizedBox(height: 10),

                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      // <-- Button color
                      overlayColor: MaterialStateProperty.resolveWith<Color?>((
                          states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blue; // <-- Splash color
                      }),
                    ),
                    onPressed: nameController.text.isNotEmpty &&
                        apodoController.text.isNotEmpty &&
                        telIntController.text.isNotEmpty &&
                        telExtController.text.isNotEmpty ? () async {
                      if (formGlobalKey.currentState!.validate()) {
                        formGlobalKey.currentState?.save();
                      }
                      try {
                        //osUserID = await getOneSignalID();
                        widget.loginControl.eventRegisterUser(widget,emailController.text.trim(),passwordController.text,nameController.text,apodoController.text,imageSelected,imagen,telIntController.text,telExtController.text);

                      } catch (e) {
                        showAlert2(context);
                      }
                    } : null,
                    //si alguno es falso, null con lo cual está desactivado
                    child: const Text(
                      'Registrar usuario',
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  Future<XFile?> selectFile() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }





  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, outPath,
      quality: 10,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }


  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 30),
              () {
            Navigator.pop(context);
          },
        );
        return AlertDialog(
          title: Text('Usuario Registrado correctamente.'),
        );
      },
    );
  }

  showAlert2(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 5),
              () {
            // Navigator.pop(context);
          },
        );

        return AlertDialog(
          title: Text('No ha sido posible registrarlo.' +
              '         Intentelo de nuevo'),
        );
      },
    );
  }

  showAlert3(BuildContext context) {
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
          title: Text('CONTRASEnA VACIA'),
        );
      },
    );
  }

  showAlert4(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 1),
              () {
            // Navigator.pop(context);

          },
        );

        return AlertDialog(
          title: Text(mensaje),
        );
      },
    );
  }


}
