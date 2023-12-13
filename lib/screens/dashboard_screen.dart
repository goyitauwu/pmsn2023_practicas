import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import '../assets/global_values.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

   //final imglogo = Image.asset('assets/dashlogo.gif', height: 350, width: 350);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenidos'),
      ),
      body: Stack(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              //imglogo,
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      drawer: createDrawer(context),
    );
  }

  Widget createDrawer(context){
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/102234549?v=4'),
            ),
            accountName: Text('Alan Sanchez'),
            accountEmail: Text('saulsanchezd@hotmail.com')
          ),
          DayNightSwitcher(
            isDarkModeEnabled: GlobalValues.flagTheme.value,
            onStateChanged: (isDarkModeEnabled) {
              GlobalValues.teme.setBool('teme', isDarkModeEnabled);
              GlobalValues.flagTheme.value = isDarkModeEnabled;
            },
          ),
          ListTile(
            leading: Icon(Icons.school, color: Theme.of(context).iconTheme.color),
            trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
            title: const Text('Tareas'),
            subtitle: const Text('Practica 4'),
            onTap: () {
              Navigator.pushNamed(context, '/practica4');
            },
          ),
          ListTile(
            leading: Icon(Icons.movie, color: Theme.of(context).iconTheme.color),
            trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
            title: const Text('Movies'),
            subtitle: const Text('Practica 5'),
            onTap: ()=> Navigator.pushNamed(context, '/popular2'),
          ),
          ListTile(
            leading: Icon(Icons.map, color: Theme.of(context).iconTheme.color),
            trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
            title: const Text('Mapas'),
            subtitle: const Text('Practica 6'),
            onTap: () {
              Navigator.pushNamed(context, '/maps2');
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud, color: Theme.of(context).iconTheme.color),
            trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
            title: const Text('Clima'),
            subtitle: const Text('Practica 6'),
            onTap: () {
              Navigator.pushNamed(context, '/weather');
            },
          ),
        ],
      ),
    );
  }
}