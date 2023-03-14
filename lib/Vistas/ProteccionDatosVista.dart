import 'package:flutter/material.dart';

class ProteccionDatosVista extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 100),
            Container(
              child: InputDecorator(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.purple, width: 5),
                    ),
                    labelText: 'Ley proteccion datos:',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("1. Al ceder tus datos y darte de alta estas dando consentimiento expreso al tratamiento de tus datos"
                          "conforme al reglamento general de proteccion de datos"),
                      Text("2. Se informa que los datos se usarán exclusivamente para facilitar la gestión de cambios de turnos"
                          "siendo alojados en un servidor gratuito de Google y bajo ningun concepto serán cedidos a terceros"),
                      Text("3. En cualquier momento podrás ejercer tu derecho de acceso, rectificación o supresion de tus datos."),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      },
                          child: Text("salir"))
                    ],
                  )
              ),
            ),
          ],
        ),
      );
  }

}