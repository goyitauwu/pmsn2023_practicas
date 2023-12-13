import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/calen/agendadb.dart';
import 'package:pmsn20232/models/calen/profesor_model.dart';
import 'package:pmsn20232/screens/calen/add_professor.dart';


class CardProfeWidget extends StatelessWidget {
  CardProfeWidget({super.key, required this.profeModel, this.agendaDB});

  ProfessorModel profeModel;
  AgendaDB? agendaDB;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Color.fromARGB(0, 90, 90, 245), borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(0, 255, 255, 255), spreadRadius: 3),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              //Text(key as String),
              Text(profeModel.nameProfessor!,style:TextStyle(color: Colors.white))
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddProfe(profeModel: profeModel))),
                child: Icon(Icons.edit, color: Theme.of(context).iconTheme.color)
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Mensaje'),
                          content: Text('¿Deseas borrar el profesor?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  agendaDB!
                                      .DELETE4('tblProfesor', 'idProfessor',
                                          profeModel.idProfessor!)
                                      .then((value) {
                                    if (value == 0) {
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Error'),
                                              content: Text('No se pudo eliminar el profesor'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('Ok')),
                                              ],
                                            );
                                          });
                                    } else {
                                      Navigator.pop(context);
                                      GlobalValues.flagPR4Profe.value =
                                          !GlobalValues.flagPR4Profe.value;
                                    }
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
