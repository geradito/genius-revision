import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'HomePage.dart';
import 'LessonTwoPage.dart';
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
  final List<String> videoUrl = <String>[
    'assets/videos/bike.mp4',
    'assets/videos/intro.mp4',
    'assets/videos/gerald.mp4',
  ];

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 2400;

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
        title: CountdownTimer(
          endTime: endTime,
        ),
        backgroundColor: Colors.blueAccent,
      ),

      body:
      FutureBuilder(
        future: fetchQuestions(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child:
              Center(
                child:
                Column(
                  children: [
                    Image.asset('assets/imgs/trophy.png'),
                    Text("Congratulations!", style: TextStyle(
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                      },
                      child: Text(
                        "Return Home",
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
}


class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}

class _ButterFlyAssetVideo extends StatefulWidget {
  String url;
  _ButterFlyAssetVideo(String s){
    this.url=s;
  }

  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState(url);
}
class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  VideoPlayerController _controller;
  String url;
  _ButterFlyAssetVideoState(String url){
    this.url =url;
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(url);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          // const Text('With assets mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}