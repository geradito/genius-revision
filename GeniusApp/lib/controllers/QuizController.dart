import 'package:get/get.dart';

class QuizController extends GetxController{

  int _categoryId = 0;
  int _gradeId = 0;
  int _subjectId = 0;
  String _subjectName;
  int _quizId = 0;
  String _question = "";
  String _diagram = "";
  String _optionA = "";
  String _optionB = "";
  String _optionC = "";
  String _optionD = "";
  String _answer = "";
  int _score = 0;


  String get subjectName => _subjectName;

  set subjectName(String value) {
    _subjectName = value;
  }

  int get score => _score;

  void increaseScore() {
    _score++;
    update();
  }

  void resetScore() {
    _score = 0;
    update();
  }

  void resetPreviousQuizIds() {
    _previousQuizIds = [];
    update();
  }

  List<int> _previousQuizIds = [];

  int get categoryId => _categoryId;

  set categoryId(int value) {
    _categoryId = value;
    update();
  }

  int get gradeId => _gradeId;

  set gradeId(int value) {
    _gradeId = value;
    update();
  }

  int get subjectId => _subjectId;

  set subjectId(int value) {
    _subjectId = value;
    update();
  }

  int get quizId => _quizId;

  set quizId(int value) {
    _quizId = value;
    update();
  }

  String get question => _question;

  set question(String value) {
    _question = value;
    update();
  }

  String get diagram => _diagram;

  set diagram(String value) {
    _diagram = value;
    update();
  }

  String get optionA => _optionA;

  set optionA(String value) {
    _optionA = value;
    update();
  }

  String get optionB => _optionB;

  set optionB(String value) {
    _optionB = value;
    update();
  }

  String get optionC => _optionC;

  set optionC(String value) {
    _optionC = value;
    update();
  }

  String get optionD => _optionD;

  set optionD(String value) {
    _optionD = value;
    update();
  }

  String get answer => _answer;

  set answer(String value) {
    _answer = value;
    update();
  }

  List<int> get previousQuizIds => _previousQuizIds;

  set previousQuizIds(List<int> value) {
    _previousQuizIds = value;
       update();
  }

// void decreaseX(){
  //   _x--;
  //   update();
  // }
}