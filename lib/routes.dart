import 'package:flutter/widgets.dart';
import 'package:pmsn20232/screens/calen/add_carrera.dart';
import 'package:pmsn20232/screens/calen/add_professor.dart';
import 'package:pmsn20232/screens/calen/add_task.dart';
import 'package:pmsn20232/screens/calen/calendar_screen.dart';
import 'package:pmsn20232/screens/calen/tareas_screen.dart';
import 'package:pmsn20232/screens/clima/listweather_screen.dart';
import 'package:pmsn20232/screens/clima/maps_screen.dart';
import 'package:pmsn20232/screens/clima/weather_screen.dart';
import 'package:pmsn20232/screens/maps_screen.dart';
import 'package:pmsn20232/screens/peli/movie_list_screen.dart';
import 'package:pmsn20232/screens/register_screen.dart';
import 'package:pmsn20232/screens/add_task.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';
import 'package:pmsn20232/screens/detail_movie_screen.dart';

import 'package:pmsn20232/screens/login_screen.dart';

import 'package:pmsn20232/screens/popular_screen.dart';

import 'package:pmsn20232/screens/task_screen.dart';


Map<String,WidgetBuilder> getRoutes(){
  return{
    '/dash' : (BuildContext contex) => DashboardScreen(),

    '/login': (BuildContext context) => const LoginScreen(),
    '/task': (BuildContext context) => const TaskScreen(),
    '/add': (BuildContext context) => AddTask(),
    '/popular': (BuildContext context) => const PopularScreen(),
    '/detail': (BuildContext context) => const DetailMovieScreen(),

    '/register': (BuildContext context) => const RegisterScreen(),
    '/maps': (BuildContext context) => const MapsScreen(),
    '/popular2': (BuildContext context) => const MovieListVideos(),
    '/practica4': (BuildContext context) => TareasScreen(),


    '/calendar': (BuildContext context) => TableEventsExample(),
    '/addTask': (BuildContext context) => AddTask2(),
    '/addProfe': (BuildContext context) => AddProfe(),
    '/addCarrera': (BuildContext context) => AddCarrera(),


    '/maps2': (BuildContext context) => const MapScreen(),
    '/weather': (BuildContext context) => WeatherScreen(),
    '/listweather': (BuildContext context) => const listWeatherMarks(),
  };
}