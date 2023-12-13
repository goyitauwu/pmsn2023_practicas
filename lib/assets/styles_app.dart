import 'package:flutter/material.dart';

class StyleApp{
  static ThemeData lightTheme(BuildContext context){
    final theme = ThemeData.light();
    return theme.copyWith(
      //primaryColor: Color.fromARGB(255, 255, 100, 50),
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: Color.fromARGB(255, 0, 50, 95),
      ),
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 0, 50, 95),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context){
    final theme = ThemeData.dark();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: Color.fromARGB(235, 0, 70, 150)     
      ),
      iconTheme: const IconThemeData(
        color: Color.fromARGB(235, 0, 70, 150),
      ),
    );
  }

  static ThemeData customTheme(BuildContext context){
    final theme = ThemeData.dark();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(240, 215, 0, 80),
        
      ),
      iconTheme: const IconThemeData(
        color: Color.fromARGB(240, 215, 0, 80),
      ),
    );
  }
}


