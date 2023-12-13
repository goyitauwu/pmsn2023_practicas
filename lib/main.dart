
import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
import 'package:pmsn20232/provider/test_provider.dart';
import 'package:pmsn20232/routes.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';

import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalValues.configPrefs();
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalValues.flagTheme.value = GlobalValues.teme.getBool('teme') ?? false;
    return ValueListenableBuilder(
      valueListenable: GlobalValues.flagTheme,
      builder: (context, value, _) {
        return ChangeNotifierProvider(
          create: (context) => TestProvider(),
          child: MaterialApp(
            home: DashboardScreen(),
            routes: getRoutes(),
            debugShowCheckedModeBanner: false,
            theme: value
            ?StyleApp.darkTheme(context)
            :StyleApp.lightTheme(context)
          ),
        );
      }
    );
  }
  
}
