import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pmsn20232/models/calen/carrera_model.dart';
import 'package:pmsn20232/models/calen/profesor_model.dart';
import 'package:pmsn20232/models/calen/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AgendaDB {
  static final nameDB = 'AGENDADB2';
  static final versionDB = 3;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
  }

  FutureOr<void> _createTables(Database db, int version) async {
    // Crear la tabla tblCarrera
    await db.execute('''
    CREATE TABLE tblCarrera(
      idCareer INTEGER PRIMARY KEY,
      nameCareer VARCHAR(50)
    )
  ''');

    // Crear la tabla tblProfesor
    await db.execute('''
    CREATE TABLE tblProfesor(
      idProfessor INTEGER PRIMARY KEY,
      nameProfessor VARCHAR(80),
      email VARCHAR(50),
      idCareer INTEGER,
      foreign key(idCareer) REFERENCES tblCarrera(idCareer)
    )
  ''');

    // Crear la tabla tblTask
    await db.execute('''
    CREATE TABLE tblTask(
      idTask INTEGER PRIMARY KEY,
      nomTask VARCHAR(100),
      fecExpiracion DATETIME,
      fecRecordatorio DATETIME,
      desTask TEXT,
      realizada INTEGER,
      idProfessor INTEGER,
      foreign key(idProfessor) REFERENCES tblProfe(idProfessor)
    )
  ''');
    
    await db.execute('''CREATE TABLE tblWeather(idLocation INTEGER PRIMARY KEY,
                                              nombre varchar(255),
                                              latitud REAL,
                                              longitud REAL
                                              );''');
  }

  Future<int> INSERT(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert(tblName, data);
  }

  //SELECT * FROM tblCarrer
  Future<List<CareerModel>> GETALLCARRERAS() async {
    var conexion = await database;
    var result = await conexion!.query('tblCarrera');
    return result.map((carrera) => CareerModel.fromMap(carrera)).toList();
  }

  //SELECT * FROM tblProfesor
  Future<List<ProfessorModel>> GETALLPROFESORES() async {
    var conexion = await database;
    var result = await conexion!.query('tblProfesor');
    return result.map((profe) => ProfessorModel.fromMap(profe)).toList();
  }

  //SELECT * FROM tblTask
  Future<List<TaskModel>> GETALLTASKS() async {
    var conexion = await database;
    var result = await conexion!.query('tblTask');
    return result.map((tasks) => TaskModel.fromMap(tasks)).toList();
  }

  //UPDATE & DELETE GENERAL
  Future<int> UPDATE4(String tblName, Map<String, dynamic> data,
      String whereCampo, int id) async {
    var conexion = await database;
    return conexion!
        .update(tblName, data, where: '$whereCampo = ?', whereArgs: [id]);
  }

  Future<bool> _hasTaskForProfe(int idProfe) async {
    var conexion = await database;
    var result = await conexion!
        .query('tblTask', where: 'idProfessor = ?', whereArgs: [idProfe]);
    return result.isNotEmpty;
  }

  Future<bool> _hasProfeForCarrera(int idCareer) async {
    var conexion = await database;
    var result = await conexion!
        .query('tblProfesor', where: 'idCareer = ?', whereArgs: [idCareer]);
    return result.isNotEmpty;
  }

  Future<List<CareerModel>> searchCarreras(String searchTerm) async {
    var conexion = await database;
    var result = await conexion!.query('tblCarrera',
        where: 'nameCareer LIKE ?', whereArgs: ['%$searchTerm%']);
    return result.map((carrera) => CareerModel.fromMap(carrera)).toList();
  }

  Future<int> DELETE4(String tblName, String whereCampo, int id) async {
    var conexion = await database;
    switch (tblName) {
      case 'tblCarrera':
        bool hasProfessors = await _hasProfeForCarrera(id);
        if (hasProfessors) {
          return 0;
        } else {
          return conexion!
              .delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
        }
      case 'tblProfesor':
        bool hasProfessors = await _hasTaskForProfe(id);
        if (hasProfessors) {
          return 0;
        } else {
          return conexion!
              .delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
        }
      case 'tblTask':
        return conexion!
            .delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
    }
    return conexion!.delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
  }

  Future<List<ProfessorModel>> searchProfesores(String searchTerm) async {
    var conexion = await database;
    var result = await conexion!.query('tblProfesor',
        where: 'nameProfessor LIKE ?', whereArgs: ['%$searchTerm%']);
    return result.map((profe) => ProfessorModel.fromMap(profe)).toList();
  }

  Future<List<TaskModel>> searchTasks(
      String searchTerm, int? selectedTaskStatus) async {
    var conexion = await database;
    String whereClause = 'nomTask LIKE ?';
    List<dynamic> whereArgs = ['%$searchTerm%'];

    if (selectedTaskStatus != null) {
      whereClause += ' AND realizada = ?';
      whereArgs.add(selectedTaskStatus);
    }
    var result = await conexion!
        .query('tblTask', where: whereClause, whereArgs: whereArgs);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<List<TaskModel>> getTareasRecordatorio(String formattedDate) async {
    var conexion = await database;
    var result = await conexion!.query('tblTask',
        where: 'DATE(fecRecordatorio) = ?', whereArgs: [formattedDate]);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<List<TaskModel>> getTareasExpiracion(String formattedDate) async {
    var conexion = await database;
    var result = await conexion!.query('tblTask',
        where: 'DATE(fecExpiracion) = ?', whereArgs: [formattedDate]);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<int> insertLocation(Map<String, dynamic> data) async {
    var connection = await database;
    return connection!.insert('tblWeather', data);
  }

  Future<int> updateLocation(Map<String, dynamic> data) async {
    var connection = await database;
    return connection!.update('tblWeather', data,
        where: 'idLocation = ?', whereArgs: [data['idLocation']]);
  }

  Future<int> deleteLocation(int idLocation) async {
    var connection = await database;
    return connection!
        .delete('tblWeather', where: 'idLocation = ?', whereArgs: [idLocation]);
  }

  Future<List<Map<String, dynamic>>> getAllLocations() async {
    var connection = await database;
    return connection!.query('tblWeather');
  }
}
