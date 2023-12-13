import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/screens/add_task.dart';

class CardTaskWidget extends StatelessWidget {
  CardTaskWidget({super.key,required this.taskModel,this.agendaDB});

  TaskModel taskModel;
  AgendaDB? agendaDB;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 62, 218, 207)
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(taskModel.nameTask!),
              Text(taskModel.dscTask!),
              Text(taskModel.sttTask!)
            ],
          ),
          Expanded(child: Container()),
          Column(
            children: [
              GestureDetector(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: ((context) => AddTask(taskModel: taskModel)))),
                child: Image.asset('assets/mango.png',height: 50,)
              ),
              IconButton(onPressed: (){
                showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: Text('Mensaje del sistema!!'),
                      content: Text('Deseas Eliminar la tarea? :('),
                      actions: [
                        TextButton(
                          onPressed: (){
                            agendaDB!.DELETE('tblTareas', taskModel.idTask!).then((value){
                              Navigator.pop(context);
                              GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
                            });
                          }, 
                          child: Text('Si 🥲')),
                        TextButton(onPressed: () => Navigator.pop(context), child: Text('No 😁')),
                      ],
                    );
                  }
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