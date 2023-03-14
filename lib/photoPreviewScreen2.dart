
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'Modelos/ModeloMaquinista.dart';

class PhotoPreviewScreen2 extends StatefulWidget {

   late ModeloMaquinista maquinista;

   PhotoPreviewScreen2(ModeloMaquinista maq){
     this.maquinista = maq;
   }

  @override
  _PhotoPreviewScreenState2 createState() => _PhotoPreviewScreenState2();
}

class _PhotoPreviewScreenState2 extends State<PhotoPreviewScreen2> {

  File? imagen = null;
  //final picker = ImagePicker();
  XFile? imageSelected;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Elegir Foto de Avatar"),
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
                children: [
                  imageSelected != null && imageSelected!.path.isNotEmpty
                  ? Image.file(File(imageSelected!.path))
                  : const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: ()async {
                    imageSelected = await selectFile();
                    if(imageSelected != null && imageSelected!.path.isNotEmpty){
                      setState((){});
                      String pathImagen = await uploadImage(imageSelected!);
                      //Se guarda en su snapshot la ruta de la imagen
                      FirebaseFirestore.instance.collection("maquinistas").doc(widget.maquinista.idMaquinista).set(
                          {
                            'imagePath':  pathImagen,
                          },SetOptions(merge: true)).then((_){
                        print("success!");
                      });
                    }
                  },
                    child: Text("Selecciona una imagen"),
                  ),
                  //imagen != null ? Image.file(imagen!) : Center(),

                ],
              ))

        ,

      ),
    );
  }

  Future<XFile?> selectFile() async{
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<String> uploadImage(XFile image) async{
    Reference db = FirebaseStorage.instance.ref("images/${getImageName(image)}");
    await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }

  String getImageName(XFile image){
    return image.path.split("/").last;
  }






}

