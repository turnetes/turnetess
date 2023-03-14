import 'package:flutter/cupertino.dart';

class SecondScreen extends StatelessWidget{

  String? payload;

  SecondScreen({
    Key? key,
    required this.payload,
  }) : super (key: key);



  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
          "HELLO SECOND SCREEN")
    );
  }

}