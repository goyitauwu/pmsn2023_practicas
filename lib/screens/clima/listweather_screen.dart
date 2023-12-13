import 'package:flutter/material.dart';
import 'package:pmsn20232/database/calen/agendadb.dart';
import 'package:pmsn20232/network/clima/api_weather.dart';
import 'package:pmsn20232/screens/clima/locationDetailScreen.dart';

class listWeatherMarks extends StatefulWidget {
  const listWeatherMarks({super.key});

  @override
  State<listWeatherMarks> createState() => _listWeatherMarksState();
}

class _listWeatherMarksState extends State<listWeatherMarks> {
  late Future<List<Map<String, dynamic>>> locations;

  @override
  void initState() {
    super.initState();
    locations = _getLocations();
  }

  Future<List<Map<String, dynamic>>> _getLocations() async {
    List<Map<String, dynamic>> locationList =
        await AgendaDB().getAllLocations();

    if (locationList != null) {
      List<Map<String, dynamic>> updatedList = [];

      WeatherLogic weatherLogic = WeatherLogic();

      for (var location in locationList) {
        double temperature = await weatherLogic.getTemperature(
            location['latitud'], location['longitud']);
        Map<String, dynamic> updatedLocation = {
          ...location,
          'temperature': temperature
        };
        updatedList.add(updatedLocation);
      }

      return updatedList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Ubicaciones'),
        actions: [
          IconButton(
            onPressed: () => _navigateToMaps(),
            icon: const Icon(Icons.map),
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      body: FutureBuilder(
        future: locations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> locationList =
                snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: locationList.length,
              itemBuilder: (context, index) {
                return _buildLocationCard(locationList[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/ubi.png'),
        ),
        title: Text(
          location['nombre'],
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Latitud: ${location['latitud']}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                'Longitud: ${location['longitud']}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                'Temperatura: ${location['temperature']}°C',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        onTap: () => _navigateToLocationDetail(location),
      ),
    );
  }

  void _navigateToMaps() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/maps2').then((value) {
      setState(() {});
    });
  }

  void _navigateToLocationDetail(Map<String, dynamic> location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailScreen(
          latitude: location['latitud'],
          longitude: location['longitud'],
        ),
      ),
    );
  }

}
