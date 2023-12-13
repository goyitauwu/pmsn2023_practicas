import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/calen/agendadb.dart';
import 'package:pmsn20232/models/calen/task_model.dart';
import 'package:pmsn20232/screens/calen/add_task.dart';

class CardTaskWidget extends StatelessWidget {
  CardTaskWidget({super.key, required this.taskModel, this.agendaDB});

  TaskModel taskModel;
  AgendaDB? agendaDB;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Color.fromARGB(0, 145, 145, 145), borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(0, 255, 255, 255), spreadRadius: 3),
        ],
      ),
      child: Row(                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
        children: [
          Column(
            children: [
              Text(''+taskModel.nomTask!,style:TextStyle(color: Colors.white)), 
              Text(''+taskModel.desTask!,style:TextStyle(color: Colors.white)),
            ],
          ),
          IconButton(
              onPressed: () {
                agendaDB!
                    .UPDATE4('tblTask', {'realizada': 2}, 'idTask',
                        taskModel.idTask!)
                    .then((value) {
                  GlobalValues.flagTask2.value =
                      !GlobalValues.flagTask2.value;
                  var msj = (value > 0)
                      ? 'La actualización fue exitosa'
                      : 'Ocurrió un error';
                  var snackbar = SnackBar(content: Text(msj));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                });
              },
              icon: Icon(Icons.check_circle)),
          Expanded(
            child: Container(),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask2(taskModel: taskModel))),
                child: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Mensaje del sistema'),
                          content: Text('¿Deseas borrar la tarea?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  agendaDB!
                                      .DELETE4('tblTask', 'idTask',
                                          taskModel.idTask!)
                                      .then((value) {
                                    Navigator.pop(context);
                                    GlobalValues.flagTask2.value =
                                        !GlobalValues.flagTask2.value;
                                  });
                                },
                                child: Text('Si')),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('No')),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }
}
