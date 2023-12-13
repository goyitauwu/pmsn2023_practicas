import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pmsn20232/network/clima/api_weather.dart';

class LocationDetailScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  LocationDetailScreen({required this.latitude, required this.longitude});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  WeatherLogic weatherLogic = WeatherLogic();
  List<Map<String, dynamic>> dailyTemperatures = [];

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  Future<void> _getWeatherData() async {
    List<Map<String, dynamic>> temperatures =
        await weatherLogic.getWeatherDetails(widget.latitude, widget.longitude);
    if (temperatures.isNotEmpty) {
      setState(() {
        dailyTemperatures = temperatures;
      });
    } else {
      // Manejar error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Ubicacion.'),
      ),
      backgroundColor: Color.fromARGB(235, 115, 230, 255),
      extendBodyBehindAppBar: true,
      body: Center(
        child: dailyTemperatures.isNotEmpty
            ? _buildWeatherContent()
            : Text('Cargando...'),
      ),
    );
  }

  Widget _buildWeatherContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 450,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color.fromARGB(200, 15, 80, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              _buildCurrentWeather(),
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Pronóstico para los siguientes días',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildNext5DaysForecast(),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${dailyTemperatures[0]['cityName']}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        LottieBuilder.asset(
          "animation/${dailyTemperatures[0]['iconCode']}.json",
          width: 100,
        ),
        Text(
          '${dailyTemperatures[0]['temperature']}°C',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${dailyTemperatures[0]['weatherDescription']}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTemperatureInfo(
              'Max',
              '${dailyTemperatures[0]['maxTemperature']}°C',
            ),
            _buildTemperatureInfo(
              'Min',
              '${dailyTemperatures[0]['minTemperature']}°C',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemperatureInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNext5DaysForecast() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: dailyTemperatures.length - 1,
        itemBuilder: (context, index) {
          return _buildWeatherCard(index + 1);
        },
      ),
    );
  }

  Widget _buildWeatherCard(int index) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 75, 155, 250),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Columna izquierda para la información actual
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dailyTemperatures[index]['date']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                LottieBuilder.asset(
                  "animation/${dailyTemperatures[index]['iconCode']}.json",
                  width: 70,
                ),
                Text(
                  '${dailyTemperatures[index]['temperature']}°C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Columna derecha para temperaturas máximas y mínimas
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTemperatureInfo(
                  'Max',
                  '${dailyTemperatures[index]['maxTemperature']}°C',
                ),
                _buildTemperatureInfo(
                  'Min',
                  '${dailyTemperatures[index]['minTemperature']}°C',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
