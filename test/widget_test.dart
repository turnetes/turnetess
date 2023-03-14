// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turnetes/peticiones4.dart';
import 'package:turnetes/confirmacionOfrecimiento.dart';
import 'package:intl/intl.dart';
import 'package:turnetes/main.dart';
/*

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

 */

/*
void main() {

  test("Test ordenación de peticiones", (){
    Turno turno1 = Turno(01,DateTime(2022,05,01),null,null,null,"turnoidMayo");
    Turno turno2 = Turno(01,DateTime(2022,06,01),null,null,null,"turnoidJunio");
    Turno turno3 = Turno(01,DateTime(2022,07,01),null,null,null,"turnoidJulio");
    Turno turno4 = Turno(01,DateTime(2022,09,01),null,null,null,"turnoidSeptiembre");
    List<Turno>? listaTurnosSinOrdenar = [];
    List<Turno>? listaTurnosOrdenados = [];
    listaTurnosSinOrdenar.add(turno3);
    listaTurnosSinOrdenar.add(turno1);
    listaTurnosSinOrdenar.add(turno4);
    listaTurnosSinOrdenar.add(turno2);
    print("Lista turnos sin ordenar: ");
    listaTurnosSinOrdenar.forEach((element) {print(element.idTurno);});
    listaTurnosOrdenados = ordenarTurnos(listaTurnosSinOrdenar);
    print("Lista turnos Ordenados: ");
    listaTurnosOrdenados!.forEach((element) {print(element.idTurno);});
    expect(ordenarTurnos(listaTurnosSinOrdenar),[turno1,turno2,turno3,turno4]);
  });

  /*
  test("Test función restriccion de turnos en Ofrecimiento", (){
    String franja = "Mañanas Mañanas";
    expect(comprobarGrafico(100,franja),true);
    expect(comprobarGrafico(160,franja),true);
    expect(comprobarGrafico(260,franja),false);

    franja = "General";
    expect(comprobarGrafico(200,franja),true);
    expect(comprobarGrafico(299,franja),true);
    expect(comprobarGrafico(310,franja),false);

    franja = "Tardes Tardes";
    expect(comprobarGrafico(300,franja),true);
    expect(comprobarGrafico(354,franja),true);
    expect(comprobarGrafico(260,franja),false);
  });

   */


  


}

List<Turno>? ordenarTurnos(List<Turno> lista){
  lista.sort((a,b) {
    int aDate = a.fecha.microsecondsSinceEpoch;
    int bDate = b.fecha.microsecondsSinceEpoch;
    return aDate.compareTo(bDate);
  });
  return lista;
}

bool comprobarGrafico(int clave,String? franja){
  dynamic i = (clave / 100);
  String? grafico;
  int x = i.toInt();
  switch (x) {
    case 1:
      grafico = "Mañanas Mañanas";
      break;
    case 2:
      grafico = "General";
      break;
    case 3:
      grafico = "Tardes Tardes";
      break;
    case 4:
      grafico = "Villalba";
      break;
    case 5:
      grafico = "Alcala";
      break;
    case 4:
      grafico = "P.Pio";
      break;
    case 7 :
      grafico = "Noche";
      break;
  }
  return franja == grafico;
}

 */

void main() {
  test("Sacar si es festivo(Sabado o Domingo):",(){
    DateTime fecha1 = DateTime(2022,09,19);
    DateTime fecha2 = DateTime(2022,09,20);
    DateTime fecha3 = DateTime(2022,09,21);
    DateTime fecha4 = DateTime(2022,09,22);
    DateTime fecha5 = DateTime(2022,09,23);
    DateTime fecha6 = DateTime(2022,09,24);
    DateTime fecha7 = DateTime(2022,09,25);
    DateTime fecha8 = DateTime(2022,10,1);
    expect(sacarFestivos(fecha1),false);
    expect(sacarFestivos(fecha2),false);
    expect(sacarFestivos(fecha3),false);
    expect(sacarFestivos(fecha4),false);
    expect(sacarFestivos(fecha5),false);
    expect(sacarFestivos(fecha6),true); //SABADO
    expect(sacarFestivos(fecha7),true); //DOMINGO
    expect(sacarFestivos(fecha8),true); //SABADO
  });

}

bool? sacarFestivos(DateTime? date2) {
  late String resp;
  if (date2 != null) {
    String dia = DateFormat('EEEE').format(date2);
    print(" el día "+ date2.day.toString() + "/"+ date2.month.toString() + "/"+ date2.year.toString() + " es :$dia");
    switch (dia) {
      case "Monday":
        return false;
      case "Tuesday":
        return false;
      case "Wednesday":
        return false;
      case "Thursday":
        return false;
      case "Friday":
        return false;
      case "Saturday":
        return true;
      case "Sunday":
        return true;
    }
  }
}