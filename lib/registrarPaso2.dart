import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:turnetes/peticiones4.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/*

class RegistrarPaso2 extends StatefulWidget{

  final String mail;
  final String pass;

  @override
  _RegistrarPaso2 createState() => _RegistrarPaso2();

  RegistrarPaso2(this.mail, this.pass);
}

class  _RegistrarPaso2 extends State<RegistrarPaso2> {

  final formGlobalKey = GlobalKey <FormState>();

  //final FirebaseAuth registro = FirebaseAuth.instance;

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
          prefixIcon: Icon(Icons.account_circle),
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
          prefixIcon: Icon(Icons.account_circle),
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
          prefixIcon: Icon(Icons.phone),
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
          prefixIcon: Icon(Icons.phone),
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
                        'assets/logoPrincipal.jpg'),),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                  ),
                  namefield,
                  SizedBox(height: 10),
                  apodofield,
                  SizedBox(height: 10),
                  telIntfield,
                  SizedBox(height: 10),
                  telExtfield,
                  SizedBox(height: 10),
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
                                                    /*
                                                TextButton(
                                                    child: const Text('Hacer foto'),
                                                    onPressed: () async {
                                                      var pickedFile;
                                                      pickedFile = await picker.pickImage(
                                                          source: ImageSource.camera);
                                                      setState(() {
                                                        if (pickedFile != null) {
                                                          imagen = File(pickedFile.path);
                                                          if(imagen != null){
                                                            imageSelected = null;
                                                            setState(() {});

                                                          }
                                                        } else {
                                                          print("No selecciono ninguna foto");
                                                        }
                                                      }

                                                      );
                                                      Navigator.pop(context);
                                                    }
                                                ),

                                                 */

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

                                                          );
                                                          //Navigator.pop(context);
                                                        }
                                                    ),


                                                    /*
                                                TextButton(
                                                    child: const Text('Buscar en Galería'),
                                                    onPressed: () async {
                                                      imageSelected = await selectFile();
                                                      if (imageSelected != null &&
                                                          imageSelected!.path.isNotEmpty) {
                                                        imagen = null;
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      }
                                                    }
                                                )
                                                */

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
                                  /*
                imageSelected != null
                    ? CircleAvatar(
                  child: Image.file(File(imageSelected!.path)))
                 //Image.file(File(imageSelected!.path))
                    : const SizedBox.shrink(),

                 */
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
                        final user = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: widget.mail, password: widget.pass);
                        print("POR AQUI LLEGA50!!!!!!");
                        if (user != null) {
                          print("POR AQUI LLEGA100!!!!!!");
                          //Pasar a Firebase nuevo usuario con id del registro
                          var firebaseUser = FirebaseAuth.instance.currentUser;
                          String id = firebaseUser!.uid;
                          //sacar el token de Signal
                          final status = await OneSignal.shared
                              .getDeviceState();
                          String? oneSignalID = status!.userId;
                          late String pathImagen;
                          if (imageSelected != null) {
                            pathImagen = await uploadImage(imageSelected!);
                          }
                          else {
                            if (imagen != null) {
                              pathImagen = await uploadImagePhoto(imagen!);
                            }
                          }
                          //String pathImagen = await uploadImage(imageSelected!);
                          //Conseguir id para notificaciones(mas tarde)
                          await FirebaseFirestore.instance.collection(
                              "maquinistas").doc(id).set(
                              {
                                'apodo': apodoController.text,
                                'contadorFestivos': 0,
                                'contadorTurnos': 0,
                                'correo': widget.mail,
                                'idMaquinista': id,
                                'imagePath': pathImagen,
                                'nombre': nameController.text,
                                'oneSignalID': oneSignalID,
                                'passAdmin': false,
                                'telfInt': telIntController.text,
                                'telfExt': telExtController.text
                              }
                          ).then((id) {
                            showAlertPrueba();
                            print("success ESTE WENO2!");
                          });
                        }
                        else {
                          showAlert4(context);
                        }
                        //showAlertPrueba();
                        //Navigator.pop(context);
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

  Future<String> uploadImage(XFile image) async {
    Reference db = FirebaseStorage.instance.ref(
        "images/${getImageName(image)}");
    await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }

  Future<String> uploadImagePhoto(File image) async {
    Reference db = FirebaseStorage.instance.ref(
        "images/${getImageNamePhoto(image)}");
    await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }

  String getImageName(XFile image) {
    return image.path
        .split("/")
        .last;
  }

  String getImageNamePhoto(File image) {
    return image.path
        .split("/")
        .last;
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

  showAlert4(BuildContext context) {
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
          title: Text('No ha sido posible registrarlo SHOWALERT4!!!!!!!!!!'),
        );
      },
    );
  }

  showAlertPrueba() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 1),
              () {
            Navigator.pop(context);
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
          title: Text('Usuario Registrado'),
        );
      },
    );
  }
}


 */
