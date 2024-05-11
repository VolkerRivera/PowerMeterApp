import 'package:flutter/material.dart';
import 'package:power_meter/data/expense_data.dart';
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

  @override
  void initState() {
    super.initState();

    //prepare data 
    Provider.of<ExpenseData>(context, listen: false).prepareData();

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold( //value es toda la informacion que necesitaremos
        backgroundColor: Colors.grey.shade200,

        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense, //< Si se pulsa el boton flotante del scaffold se abre el cuadro de dialogo para añadir gastos
          child: const Icon(Icons.add),
          ),

        body: ListView(
          children: [
            // Espacio
            const SizedBox( height: 20,),

            // wekkly summary -> grafico de gastos
            ExpenseSummary(startOfWeek: value.startOfWeekDate()), // el metodo startOfWeekDate() proviene de ExpenseData

            //expense list -> lista de gastos
            ListView.builder( // siempre que representamos una lista dentro de una lista debemos añadir shrinkwrap y physics:
            shrinkWrap: true, // Creates a scrollable, linear array of widgets that are created on demand.
            physics: const NeverScrollableScrollPhysics(), //para que no se pueda scrollear sino que solo muestre lo ultimo
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context, index) => ListTile( // Representa la lista
              title: Text(value.getAllExpenseList()[index].amountKWh),
              subtitle: Text(value.getAllExpenseList()[index].dateTime.toString()),
              trailing: Text(value.getAllExpenseList()[index].amountEuro),
            )),
          ],
        ),
      ),
    );
  }
}