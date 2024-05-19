import 'package:flutter/material.dart';
import 'package:power_meter/data/expense_data.dart';
import 'package:power_meter/datetime/date_time_helper.dart';
import 'package:power_meter/mqtt/state/mqtt_register_state.dart';
import 'package:power_meter/presentation/items/expense_summary.dart';
import 'package:power_meter/presentation/models/expense_item.dart';
import 'package:provider/provider.dart';

class GraphicsPage extends StatefulWidget {
  const GraphicsPage({super.key});

  @override
  State<GraphicsPage> createState() => _GraphicsPageState();
}


class _GraphicsPageState extends State<GraphicsPage> {

  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
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
    DateTime _dateTimeMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  // add data automatically

  void _onRegisterStateChange() {
    // Esta función se llamará solo cuando MQTTRegisterState notifique un cambio
    if(mounted){
      final expenseData = Provider.of<ExpenseData>(context, listen: false);
      final registerData = currentRegisterState.getNewExpense; 

      if ( registerData != null ) {
      expenseData.addNewExpense(registerData);
      //registerState.clearReceivedText();
      }
    }
    
  }

  void addExpenseFromMQTT(ExpenseItem newExpense){
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
  }
  // add new expense -> En nuestro caso tendra que ser actualizar datos y recibirlos de la esp
  void addNewExpense(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min, //< Para que el cuadro de texto no ocupe toda la pantalla
          children: [
          // expense name
            TextField(
              controller: newExpenseNameController,
            ),
          // expense amount
            TextField(
              controller: newExpenseAmountController,
            )
          ],
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save, //Si se pulsa save de dentro del cuadro de dialogo se guardan los datos que hay en los fieldtext
            child: const Text('Save'),
          ),
          //cancel button
          MaterialButton(
            onPressed: cancel, //Si se pulsa save de dentro del cuadro de dialogo se guardan los datos que hay en los fieldtext
            child: const Text('Cancel'),
          )
        ],
      ));
  }

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
            /*const Divider(), //Añadir si mas de un mes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: (){
                      setState(() {
                        semana = true;
                      });
                      Navigator.pop(context);
                      configCharts();
                    },
                    color: semana ? const Color.fromARGB(255, 253, 227, 255) : null,
                    child: const Text('Semana'),
                  ),
                  MaterialButton(
                    onPressed: (){
                      setState(() {
                        semana = false;
                      });
                      Navigator.pop(context);
                      configCharts();
                    },
                    color: !semana ? const Color.fromARGB(255, 253, 227, 255) : null,
                    child: const Text('Mes'),
                  )
                ]
              ),
            )*/
          ],
        ),
      )
    );
  }

  // podemos crear los metodos save y cancel debajo ya que no es como en C que tienen que estar previamente definidos
  // Aqui sera donde entre el gestor de estados ya que dependiendo de lo que hagamos ira cambiando lo que se ve en la pantalla

  // save
  void save(){ 
    // create expense item
    ExpenseItem newExpense = ExpenseItem(
      amountKWh: newExpenseNameController.text, 
      amountEuro: newExpenseAmountController.text, 
      dateTime: DateTime.now()
    );

    // Once created, add it to the list
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    //despues de guardar se cierra el dialogo
    Navigator.pop(context); // APRENDER BIEN EL CONCEPTO DE CONTEXT
    clear();
  }

  // delete expense
  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // cancel
  void cancel(){
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear(){
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
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
    //final MQTTRegisterState registerState = Provider.of<MQTTRegisterState>(context, listen: false);
    //currentRegisterState = registerState;

    return Consumer<ExpenseData>( // se retorna un Scaffold
      builder: (context, value, child)  { // nuevo, antes => Scaffold...
      /*final registerData = registerState.getNewExpense;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(registerData != null ){
        addExpenseFromMQTT(registerData);
        print('Se ha añadido un objeto: ${registerData.amountEuro} €, ${registerData.amountKWh} kWh, ${registerData.dateTime.toString()}');
      } 
      });*/
      
      
      return Scaffold( //value es toda la informacion que necesitaremos
        //backgroundColor: Colors.grey.shade50,

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: addNewExpense, //< Si se pulsa el boton flotante del scaffold se abre el cuadro de dialogo para añadir gastos
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10,),
            FloatingActionButton(
              // Si se pulsa el boton flotante del scaffold se abre el cuadro de dialogo para añadir gastos
              onPressed: configCharts,
              child: const Icon(Icons.list),
            ),
          ],
        ),

        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: MaterialButton(  
                onPressed: () {
                  showDatePicker(
                    context: context, 
                    locale: const Locale('es', 'ES'),
                    currentDate: _dateTimeWeek,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023), 
                    lastDate: DateTime(2025)
                    ).then((value) {
                     setState(() {
                      _dateTimeWeek = value ?? _dateTimeWeek;
                    });
                  });   
                }, //abre el caleadario
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 5),
                      child: Icon(Icons.calendar_month),
                    ),
                    Text( //rango de fecha
                      '${goToMonday(_dateTimeWeek).day} ${nombreMes(goToMonday(_dateTimeWeek))} - ${goToMonday(_dateTimeWeek).add(const Duration(days: 6)).day} ${nombreMes(goToMonday(_dateTimeWeek).add(const Duration(days: 6)))}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),

            // wekkly summary -> grafico de gastos
            ExpenseSummaryWeek(startOfWeek: value.startOfWeekDate(_dateTimeWeek), euro: euro), // el metodo startOfWeekDate() proviene de ExpenseData

            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: MaterialButton(  
                onPressed: () {
                  showDatePicker(
                    context: context, 
                    locale: const Locale('es', 'ES'),
                    initialDate: _dateTimeMonth,
                    firstDate: DateTime(2023), 
                    lastDate: DateTime(2025)
                    ).then((value) {
                     setState(() {
                      _dateTimeMonth = value ?? _dateTimeMonth;
                    });
                  });   
                }, //abre el caleadario
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 5),
                      child: Icon(Icons.calendar_month),
                    ),
                    Text( //rango de fecha
                      '${nombreMes(_dateTimeMonth)} ${_dateTimeMonth.year}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
            //ExpenseSummaryWeek(startOfWeek: value.startOfWeekDate(), euro: false),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ExpenseSummaryMonth(startOfMonth: goToFirstDay(_dateTimeMonth), euro: euro),
            )
            
            //expense list -> lista de gastos
            /*ListView.builder( // siempre que representamos una lista dentro de una lista debemos añadir shrinkwrap y physics:
            shrinkWrap: true, // Creates a scrollable, linear array of widgets that are created on demand.
            physics: const NeverScrollableScrollPhysics(), //para que no se pueda scrollear sino que solo muestre lo ultimo
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context, index) => ListTile( // Representa la lista
              title: Text(value.getAllExpenseList()[index].amountKWh),
              subtitle: Text(value.getAllExpenseList()[index].dateTime.toString()),
              trailing: Text(value.getAllExpenseList()[index].amountEuro),
            )),*/
          ],
        ),
      );
    }

    );
  }
}