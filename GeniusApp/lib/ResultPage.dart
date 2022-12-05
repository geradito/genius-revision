import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'LoginPage.dart';
import 'controllers/QuizController.dart';
import 'controllers/UserAccountController.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPage createState() => _ResultPage();

}

class _ResultPage extends State<ResultPage> {
  QuizController  quizController= Get.put(QuizController());
  UserAccountController userAccountController = Get.put(UserAccountController());


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            Container(
              child:
              Center(
                  child:
                  Column(
                    children: [
                      Text("Result", style: TextStyle(
                          fontSize: 40,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Colors.cyan)),
                      Opacity(opacity: quizController.score<50?0.0:1.0,
                      child:Image.asset('assets/imgs/trophy.png'),),
                      Text(quizController.score<30? "You Can Improve":"Congratulations!", style: TextStyle(
                          fontSize: 40,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Colors.cyan)),
                      Text(userAccountController.username, style: TextStyle(
                          fontSize: 30,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.cyan)),
                      Text("Your Score is "+quizController.score.toString()+" out of "+quizController.previousQuizIds.length.toString(), style: TextStyle(fontSize: 20),),
                      RaisedButton(
                        elevation: 5.0,
                        color: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        onPressed: (){
                          quizController.resetScore();
                          quizController.resetPreviousQuizIds();
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            LoginPage()), (Route<dynamic> route) => false);
                        },
                        child: Text(
                          "Finish",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: MediaQuery.of(context).size.height / 40,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            )
          ],
        ),
      )
    );
  }
}
