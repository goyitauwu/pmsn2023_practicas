import 'package:flutter/material.dart';

class TestProvider with ChangeNotifier{
  String _user = '';
  String get user => _user;
  set user(String value){
    this._user = value;
    notifyListeners();
  }

  bool _flagListPost=false;

  getflagListPost()=> this._flagListPost;
  setflagListPost(){
    this._flagListPost=!_flagListPost;
    notifyListeners();
  }
}