


import 'package:cross_file/cross_file.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoPreviewScreen extends StatefulWidget {

  @override
  _PhotoPreviewScreenState createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {

  File? imagen;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ElevatedButton(onPressed: (){
                opciones(context);
              },
                   child: Text("Selecciona una imagen"),
              ),
              imagen != null ? Image.file(imagen!) : Center(),
            ],
          ))

        ],

      ),
    );
  }

  opciones(context){
    showDialog(context: context,
              builder: (BuildContext context)
    {
      return AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_setImageView()
              InkWell(
                onTap: () {
                  selImagen(1);

                },
                child: Container(
                  padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("Tomar una foto"),
                        )
                      ],
                    )
                ),
              ),
              InkWell(
                onTap: () {
                  selImagen(2);
                },
                child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("Seleccionar una foto"),
                        )
                      ],
                    )
                ),
              )
            ],
          ),

        ),
      );
    });
  }

  Future selImagen(int op) async{
    var pickedFile;
    if(op == 1){
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }
    else{
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    setState((){
      if (pickedFile != null) {
        imagen = File(pickedFile.path);
      } else {
        print("No selecciono ninguna foto");
      }

    });
    Navigator.pop(context);
  }
}