import 'package:dnlbook/utils/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'HomePage.dart';
import 'ResultPage.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'config.dart' as config;
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'controllers/QuizController.dart';
import 'controllers/UserAccountController.dart';
import 'dart:io';
import 'models/UserModel.dart';
import 'package:sqflite/sqflite.dart';

class LessonPage extends StatefulWidget{
  @override
  _LessonPage createState() => _LessonPage();

}

class Question {
  final int id;
  final String question;
  final String image;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String answer;

  const Question({
    this.id,
    this.question,
    this.image,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      image: json['image'],
      optionA: json['option_a'],
      optionB: json['option_b'],
      optionC: json['option_c'],
      optionD: json['option_d'],
      answer: json['answer'],
    );
  }
}

class _LessonPage extends State<LessonPage> {



  List<Question> futureGrades;

  Future<List<Question>> fetchQuestions() async{
    QuizController  quizController= Get.put(QuizController());
    var url = config.testURL+'/quizzes';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, dynamic>{
        'previous_questions': quizController.previousQuizIds,
        'subject_id':quizController.subjectId,
      }),
    );
    if (response.statusCode == 200) {
      var responseData = convert.jsonDecode(response.body);

      //Creating a list to store input data;
      List<Question> questions = [];

      if(responseData.length ==0){
        return questions;
      }
        Question question = Question(
            id: responseData["id"],
            question: responseData["question"],
            image: responseData["diagram"],
            optionA: responseData["option_a"],
            optionB: responseData["option_b"],
            optionC: responseData["option_c"],
            optionD: responseData["option_d"],
            answer: responseData["answer"]);
        //Adding user to the list.
        questions.add(question);
      return questions;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void updateUserPoints(int points) async{
    UserAccountController userAccountController = Get.find();

    DatabaseHelper databaseHelper = DatabaseHelper();
    User user= new User.withId(userAccountController.userId,userAccountController.username, userAccountController.level, userAccountController.points);
    int result = await databaseHelper.updateUser(user);
    if (result != 0) {  // Success
    //  _showAlertDialog('Status', 'You have earned $points');
    } else {  // Failure
    //  _showAlertDialog('Status', 'Problem Saving User');
    }
  }

  @override
  Widget build(BuildContext context) {
    QuizController  quizController= Get.put(QuizController());
    UserAccountController userAccountController = Get.put(UserAccountController());

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            quizController.resetScore();
            quizController.resetPreviousQuizIds();
            Navigator.pop(context); },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: Text(quizController.subjectName),
        backgroundColor: Colors.blueAccent,
      ),

      body:
      FutureBuilder(
        future: fetchQuestions(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          int newPoints =0;
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else
          if(snapshot.data.length == 0){
              if(quizController.score >= 60){
                newPoints = 10;
              }else if(quizController.score >= 50 && quizController.score < 60){
                newPoints =5;
              }else if(quizController.score >= 40 && quizController.score < 50){
                newPoints =4;
              }else if(quizController.score >= 30 && quizController.score < 40){
                newPoints =3;
              }else if(quizController.score >= 20 && quizController.score < 30){
                newPoints =2;
              }else if(quizController.score >= 10 && quizController.score < 20){
                newPoints =1;
              }
            userAccountController.increasePoints(newPoints);
            updateUserPoints(newPoints);
             return Card(
               color: Colors.white,
               borderOnForeground: true,
               elevation: 10,
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   ListTile(
                     title: Text("The End",style: TextStyle(
                       letterSpacing: 1.5,
                       fontSize: MediaQuery.of(context).size.height / 40,
                     )),
                     subtitle: Text(newPoints==0? "Lets now view your results":"You have earned $newPoints, Lets now view your results"),
                   ),
                   RaisedButton(
                     elevation: 5.0,
                     color: Colors.pink,
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(30.0)
                     ),
                     onPressed: () async{
                       //Navigator.pop(context);
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultPage()));
                     },
                     child: Text(
                       "View Results",
                       style: TextStyle(
                         color: Colors.white,
                         letterSpacing: 1.5,
                         fontSize: MediaQuery.of(context).size.height / 40,
                       ),
                     ),
                   )
                 ],
               ),
             );
          }
          else {
            return
              ListView(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            snapshot.data[0].question,
                            style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: snapshot.data[0].image != ""?
                              Image.network(config.imageURL+snapshot.data[0].image,
                                width: snapshot.data[0].image==""?10:400,
                                height: snapshot.data[0].image==""?10:350,)
                                :SizedBox()
                        ),
                      ],
                    ),
                  ),    //  _ButterFlyAssetVideo(videoUrl[2]),
                  Expanded(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 5.0,
                              color: Colors.pink,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              onPressed: () async {
                                SweetAlert.show(context,
                                    title: snapshot.data[0].optionA == snapshot.data[0].answer?"Correct Answer":"Wrong answer",
                                    style: snapshot.data[0].optionA == snapshot.data[0].answer?SweetAlertStyle.success:SweetAlertStyle.error,
                                    onPress: redirect());
                                AssetsAudioPlayer.newPlayer().open(
                                  Audio(snapshot.data[0].optionA == snapshot.data[0].answer?"assets/sounds/correct.mp3":"assets/sounds/wrong.mp3"),
                                  showNotification: true,
                                );
                                if(snapshot.data[0].optionA == snapshot.data[0].answer){
                                  quizController.increaseScore();
                                }
                                quizController.previousQuizIds.add(snapshot.data[0].id);
                              },
                              child: Text(
                                snapshot.data[0].optionA,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 5.0,
                              color: Colors.pink,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              onPressed: (){
                                SweetAlert.show(context,
                                    title: snapshot.data[0].optionB == snapshot.data[0].answer?"Correct Answer":"Wrong answer",
                                    style: snapshot.data[0].optionB == snapshot.data[0].answer?SweetAlertStyle.success:SweetAlertStyle.error,
                                    onPress: redirect());
                                AssetsAudioPlayer.newPlayer().open(
                                  Audio(snapshot.data[0].optionB == snapshot.data[0].answer?"assets/sounds/correct.mp3":"assets/sounds/wrong.mp3"),
                                  showNotification: true,
                                );
                                if(snapshot.data[0].optionB == snapshot.data[0].answer){
                                  quizController.increaseScore();
                                }
                                quizController.previousQuizIds.add(snapshot.data[0].id);
                              },
                              child: Text(
                                snapshot.data[0].optionB,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 5.0,
                              color: Colors.pink,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              onPressed: (){
                                SweetAlert.show(context,
                                    title: snapshot.data[0].optionC == snapshot.data[0].answer?"Correct Answer":"Wrong answer",
                                    style: snapshot.data[0].optionC == snapshot.data[0].answer?SweetAlertStyle.success:SweetAlertStyle.error,
                                    onPress: redirect());
                                AssetsAudioPlayer.newPlayer().open(
                                  Audio(snapshot.data[0].optionC == snapshot.data[0].answer?"assets/sounds/correct.mp3":"assets/sounds/wrong.mp3"),
                                  showNotification: true,
                                );
                                if(snapshot.data[0].optionC == snapshot.data[0].answer){
                                  quizController.increaseScore();
                                }
                                quizController.previousQuizIds.add(snapshot.data[0].id);
                              },
                              child: Text(
                                snapshot.data[0].optionC,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 5.0,
                              color: Colors.pink,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              onPressed: (){
                                SweetAlert.show(context,
                                    title: snapshot.data[0].optionD == snapshot.data[0].answer?"Correct Answer":"Wrong answer",
                                    style: snapshot.data[0].optionD == snapshot.data[0].answer?SweetAlertStyle.success:SweetAlertStyle.error
                                ,onPress: redirect());

                                AssetsAudioPlayer.newPlayer().open(
                                  Audio(snapshot.data[0].optionD == snapshot.data[0].answer?"assets/sounds/correct.mp3":"assets/sounds/wrong.mp3"),
                                  showNotification: true,
                                );
                                if(snapshot.data[0].optionD == snapshot.data[0].answer){
                                  quizController.increaseScore();
                                }
                                quizController.previousQuizIds.add(snapshot.data[0].id);
                              },
                              child: Text(
                                snapshot.data[0].optionD,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              );

          }
        },
      ),
    );
  }

  redirect() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LessonPage()));
  }
  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}