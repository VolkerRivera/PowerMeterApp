import 'package:flutter/material.dart';
import 'package:power_meter/data/expenses/expense_data.dart';
import 'package:power_meter/datetime/date_time_helper.dart';
import 'package:power_meter/mqtt/state/mqtt_register_state.dart';
import 'package:power_meter/data/expenses/expense_summary.dart';
import 'package:power_meter/data/expenses/expense_item.dart';
import 'package:power_meter/presentation/screens/mqtt_view_screen.dart';
import 'package:provider/provider.dart';

class GraphicsPage extends StatefulWidget {
  const GraphicsPage({super.key});

  @override
  State<GraphicsPage> createState() => _GraphicsPageState();
}


class _GraphicsPageState extends State<GraphicsPage> {

  bool euro = true;
  bool semana = true;
  late MQTTRegisterState currentRegisterState;

  @override
  void initState() {
    super.initState();

    //prepare data 
    Provider.of<ExpenseData>(context, listen: false).prepareData();
    currentRegisterState = Provider.of<MQTTRegisterState>(context, listen: false);
    currentRegisterState.addListener(_onRegisterStateChange);
  }

  // day from calendar
    DateTime _dateTimeWeek = DateTime.now();

  // add data automatically

  void _onRegisterStateChange() {
    // Esta función se llamará solo cuando MQTTRegisterState notifique un cambio
    if(mounted){
      final expenseData = Provider.of<ExpenseData>(context, listen: false);
      //final registerData = currentRegisterState.getNewExpense; 
      final List<ExpenseItem> newExpenseList = currentRegisterState.getExpenseList;

      if(newExpenseList.isNotEmpty){
        for (var expense in newExpenseList) {  // Iteramos sobre la lista
          expenseData.addNewExpense(expense);  // Añadimos cada gasto
        }
        currentRegisterState.clearExpenseList();
      }

    }
    
  }

  void addExpenseFromMQTT(ExpenseItem newExpense){
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
  }
  // add new expense -> En nuestro caso tendra que ser actualizar datos y recibirlos de la esp


  void configCharts(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Configurar gráfico', textAlign: TextAlign.center,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: (){
                      setState(() {
                        euro = true;
                      });
                      Navigator.pop(context);
                      //configCharts(); //si se quiere dejar la ventana abierta y que se muestre el cambio en el dialog
                    },
                    color: euro ? const Color.fromARGB(255, 231, 227, 255) : null,
                    child: const Icon(Icons.euro),
                  ),
                  MaterialButton(
                    onPressed: (){
                      setState(() {
                        euro = false;
                      });
                    Navigator.pop(context);
                    //configCharts(); //si se quiere dejar la ventana abierta y que se muestre el cambio en el dialog
                    },
                    color: !euro ? const Color.fromARGB(255, 231, 227, 255) : null,
                    child: const Icon(Icons.energy_savings_leaf_rounded),
                  )
                ]   
              ),
            ),
          ],
        ),
      )
    );
  }

  // podemos crear los metodos save y cancel debajo ya que no es como en C que tienen que estar previamente definidos
  // Aqui sera donde entre el gestor de estados ya que dependiendo de lo que hagamos ira cambiando lo que se ve en la pantalla


  // delete expense
  void deleteExpense(){
    Provider.of<ExpenseData>(context, listen: false).deleteExpenses();
  }

  //get weekday (mon, tues, etc) from DateTime object
  String getDayName(DateTime dateTime) {
    //Tras meterle un yyyy/mm/dd hh:mm:ss:az devuelve solo el dia de la semana en string
    switch (dateTime.weekday) {
      case 1:
        return 'L';
      case 2:
        return 'M';
      case 3:
        return 'X';
      case 4:
        return 'J';
      case 5:
        return 'V';
      case 6:
        return 'S';
      case 7:
        return 'D';
      default:
        return '';
    }
  }

  DateTime goToMonday(DateTime fromThisDay) {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = fromThisDay;

    // go backwards from today to find monday
    /* this line calculates the date i days before the current date (today). For example, when i is 0, 
    it calculates today's date. When i is 1, it calculates yesterday's date, and so on. */
    for (int i = 0; i < 7; i++) {
      // vamos i dias hacia atras a partir de la fecha de hoy
      if (getDayName(today.subtract(Duration(days: i))) == 'L') { //va restando días hasta que da con el lunes
        // Cuando coincide que hace i dias fue lunes, obtenemos la fecha para dicho dia, lo asignamos a startOfWeek y retornamos
        startOfWeek = today.subtract(Duration(days: i)); // para semanas pasadas bucle [1,7] y asi se retorna el anterior lunes??
      }
    }
    return startOfWeek!; // la exclamacion es cuando estamos seguros de que tendra valor aun siendo nullable
  }

  DateTime goToFirstDay(DateTime fromThisDay){
    return DateTime(fromThisDay.year, fromThisDay.month, 1);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ExpenseData>( // se retorna un Scaffold
      builder: (context, value, child)  { 

      return Scaffold( //value es toda la informacion que necesitaremos

        appBar: AppBar(
          actions: [
            
            MaterialButton(onPressed: (){
              if(currentRegisterState.getAppConnectionState == MQTTRegisterConnectionState.connected){
                // borrar lista Y MEMORIA
                deleteExpense();
                // pedir datos
                mqttManager.publish('updateInfo');
              }
            }, child: const Icon(Icons.update),),
            const Spacer(), // Empuja el segundo botón al extremo derecho
            MaterialButton(onPressed: configCharts, child: const Icon(Icons.currency_exchange),),
            
          ],
        ),

        body: ListView(
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: MaterialButton(  
                onPressed: () {
                  showDatePicker(
                    context: context, 
                    locale: const Locale('es', 'ES'),
                    currentDate: _dateTimeWeek,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023), 
                    lastDate: DateTime(2029)
                    ).then((value) {
                     setState(() {
                      _dateTimeWeek = value ?? _dateTimeWeek;
                    });
                  });   
                }, //abre el calendario
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 5),
                      child: Icon(Icons.calendar_month),
                    ),
                    Text( //rango de fecha
                      '${_dateTimeWeek.day} ${nombreMes(_dateTimeWeek)} ${_dateTimeWeek.year}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),

            ExpenseSummaryDay(dayToConsult: _dateTimeWeek, euro: euro),

            // wekkly summary -> grafico de gastos
            ExpenseSummaryWeek(startOfWeek: value.startOfWeekDate(_dateTimeWeek), euro: euro), // el metodo startOfWeekDate() proviene de ExpenseData

            //ExpenseSummaryWeek(startOfWeek: value.startOfWeekDate(), euro: false),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ExpenseSummaryMonth(startOfMonth: goToFirstDay(_dateTimeWeek), euro: euro),
            )
            
          ],
        ),
      );
    }

    );
  }
}