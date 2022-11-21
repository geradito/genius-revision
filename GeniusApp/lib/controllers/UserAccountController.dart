import 'package:get/get.dart';

class UserAccountController extends GetxController{
  String _username;
  int _level = 1;
  DateTime _dateOfBirth;

  int get level => _level;

  set level(int value) {
    _level = value;
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