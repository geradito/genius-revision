import 'package:get/get.dart';

class UserAccountController extends GetxController{
  int _userId;

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  String _username;
  int _level ;
  DateTime _dateOfBirth;
  int _points = 0;

  int get level => _level;

  int get points => _points;

  set level(int value) {
    _level = value;
    update();
  }


  set points(int points) {
    _points = points;
    update();
  }
  void increasePoints(int points) {
    _points += points;
    update();
  }

  DateTime get dateOfBirth => _dateOfBirth;

  set dateOfBirth(DateTime value) {
    _dateOfBirth = value;
    update();
  }

  String get username => _username;

  set username(String value) {
    _username = value;
    update();
  }
}