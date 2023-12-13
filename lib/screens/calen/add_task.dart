import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/calen/agendadb.dart';
import 'package:pmsn20232/models/calen/profesor_model.dart';
import 'package:pmsn20232/models/calen/task_model.dart';

// ignore: must_be_immutable
class AddTask2 extends StatefulWidget {
  AddTask2({super.key, this.taskModel});

  TaskModel? taskModel;

  @override
  State<AddTask2> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask2> {
  //final _formKey = GlobalKey<FormState>();
  TextEditingController taskNameController = TextEditingController();
  DateTime? expiracionDate = DateTime.now();
  DateTime? recordatorioDate = DateTime.now();
  TextEditingController taskDescController = TextEditingController();
  int? selectedTaskStatus;
  int? selectedidProfessorsor;
  List<TaskStatus> taskStatusList = [
    TaskStatus(0, 'Pendiente'),
    TaskStatus(1, 'En proceso'),
    TaskStatus(2, 'Completada'),
  ];
  List<ProfessorModel> profesores = [];

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    if (widget.taskModel != null) {
      taskNameController.text = widget.taskModel!.nomTask!;
      expiracionDate = widget.taskModel?.fecExpiracion;
      recordatorioDate = widget.taskModel?.fecRecordatorio;
      taskDescController.text = widget.taskModel!.desTask!;
      selectedTaskStatus = widget.taskModel?.realizada;
      selectedidProfessorsor = widget.taskModel?.idProfessor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtNameTask = TextFormField(
      decoration: const InputDecoration(
          label: Text('Tarea'), border: OutlineInputBorder()),
      controller: taskNameController,
    );

    final txtDescTask = TextFormField(
      decoration: const InputDecoration(
          label: Text('Descripcion'), border: OutlineInputBorder()),
      controller: taskDescController,
    );

    const space = SizedBox(
      height: 10,
    );

    final ElevatedButton btnGuardar = ElevatedButton(
        onPressed: () {
          if (widget.taskModel == null) {
            if (taskNameController.text != '' &&
                taskDescController.text != '' &&
                selectedTaskStatus != null &&
                selectedidProfessorsor != null) {
              agendaDB!.INSERT('tblTask', {
                'nomTask': taskNameController.text,
                'fecExpiracion': expiracionDate!.toIso8601String(),
                'fecRecordatorio': recordatorioDate!.toIso8601String(),
                'desTask': taskDescController.text,
                'realizada': selectedTaskStatus,
                'idProfessor': selectedidProfessorsor,
              }).then((value) {
                var msj = (value > 0)
                    ? 'La inserción fue exitosa'
                    : 'Ocurrió un error';
                var snackbar = SnackBar(content: Text(msj));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                Navigator.pop(context);
              });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Awas'),
                      content: const Text('Llena todos los datos profis'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Entendido')),
                      ],
                    );
                  });
            }
          } else {
            agendaDB!
                .UPDATE4(
                    'tblTask',
                    {
                      'idTask': widget.taskModel!.idTask,
                      'nomTask': taskNameController.text,
                      'fecExpiracion': expiracionDate!.toIso8601String(),
                      'fecRecordatorio': recordatorioDate!.toIso8601String(),
                      'desTask': taskDescController.text,
                      'realizada': selectedTaskStatus,
                      'idProfessor': selectedidProfessorsor,
                    },
                    'idTask',
                    widget.taskModel!.idTask!)
                .then((value) {
              GlobalValues.flagTask2.value = !GlobalValues.flagTask2.value;
              var msj = (value > 0)
                  ? 'La actualización fue exitosa'
                  : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            });
          }
        },
        child: const Text('Guardar Tarea'));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: widget.taskModel == null
            ? const Text('Agregar Tarea')
            : const Text('Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            txtNameTask,
            space,
            DateTimePicker(
              labelText: 'Fecha de Expiración',
              selectedDate: expiracionDate ?? DateTime.now(),
              onDateSelected: (date) {
                setState(() {
                  expiracionDate = date;
                });
              },
            ),
            space,
            DateTimePicker(
              labelText: 'Fecha de Recordatorio',
              selectedDate: recordatorioDate ?? DateTime.now(),
              onDateSelected: (date) {
                setState(() {
                  recordatorioDate = date;
                });
              },
            ),
            space,
            txtDescTask,
            space,
            DropdownButtonFormField<int>(
              value: selectedTaskStatus,
              items: taskStatusList.map((status) {
                return DropdownMenuItem<int>(
                  value: status.value,
                  child: Text(status.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTaskStatus = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Estado',
              ),
            ),
            space,
            FutureBuilder<List<ProfessorModel>>(
              future: agendaDB!.GETALLPROFESORES(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    profesores = snapshot.data!;
                    return DropdownButtonFormField<int>(
                      value: selectedidProfessorsor,
                      items: profesores.map((profesor) {
                        return DropdownMenuItem<int>(
                          value: profesor.idProfessor,
                          child: Text(profesor.nameProfessor!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedidProfessorsor = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Profesor'),
                    );
                  } else {
                    return const Text('No se encontraron profesores');
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            space,
            btnGuardar
          ],
        ),
      ),
    );
  }
}

class TaskStatus {
  final int value;
  final String label;

  TaskStatus(this.value, this.label);
}

class DateTimePicker extends StatelessWidget {
  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  DateTimePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2123),
            ).then((date) {
              if (date != null) {
                onDateSelected(date);
              }
            });
          },
          child: Text(
            selectedDate.toLocal().toString().split(' ')[0],
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
