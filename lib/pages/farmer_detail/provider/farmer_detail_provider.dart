import 'package:flutter/widgets.dart';

class FarmerDetailProvider with ChangeNotifier{

  String _cropValue,_acersValue;

  String get cropValue => _cropValue;
  String get acerValue => _acersValue;

  void setCropValue(String value){
    _cropValue = value;
    notifyListeners();
  }

  void setAcers(String value){
    _acersValue = value;
    notifyListeners();
  }
}