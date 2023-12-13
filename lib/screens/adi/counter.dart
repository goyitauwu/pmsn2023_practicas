import 'package:flutter/material.dart';

class CounterDesign extends StatefulWidget {
  const CounterDesign({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CounterDesign();
  }
}

class _CounterDesign extends State<CounterDesign> {
  int _n = 0;
  int _amt = 0;
  void add() {
    setState(() {
      _n++;
      _amt = _amt + 15;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
      _amt = _amt - 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 160.0,
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: <Widget>[
              new IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: () {
                  add();
                },
              ),
              const SizedBox(
                width: 10.0,
              ),
              new Text('$_n', style: new TextStyle(fontSize: 20.0)),
              const SizedBox(
                width: 10.0,
              ),
              new IconButton(
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                onPressed: () {
                  minus();
                },
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 80.0,
        ),
        Container(
            child: Text(
          'MXN $_amt',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        )),
      ],
    );
  }
}