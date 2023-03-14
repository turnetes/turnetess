import 'package:flutter/cupertino.dart';

class ProbandoClickNotifications extends StatelessWidget{

  int numero;


  ProbandoClickNotifications(this.numero);


  @override
  Widget build(BuildContext context) {

    return Container(
        child: Text("HOLA VENGA VIENE POR AQUI y el numero es: " + numero.toString())
    );
  }

}