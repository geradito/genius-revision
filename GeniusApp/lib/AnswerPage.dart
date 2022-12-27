import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart' as config;
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'controllers/QuizController.dart';
import 'controllers/UserAccountController.dart';

// TODO: Import ad_helper.dart
import 'utils/AdHelper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
class AnswerPage extends StatefulWidget {
  @override
  _AnswerPage createState() => _AnswerPage();
}

class _AnswerPage extends State<AnswerPage> {

  int i = 0;
  Color my = Colors.brown,
      CheckMyColor = Colors.white;

  //Creating a list to store input data;
  Future<List<Question>> questions;

  // TODO: Add _bannerAd
  BannerAd _bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    questions = fetchAnswers();

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  // TODO: Add _kAdIndex
  static final _kAdIndex = 1;

// TODO: Add _getDestinationItemIndex()
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _bannerAd != null) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  @override
  Widget build(BuildContext context) {

    var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: Text("Answers"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        future: questions,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          int newPoints = 0;
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length+
                  (_bannerAd != null ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (_bannerAd != null && index == 0) {
                  return Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: 72.0,
                    alignment: Alignment.center,
                    child: AdWidget(ad: _bannerAd),
                  );
                }else{
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5.0),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: i == 0
                                    ? Colors.amber
                                    : i == 1
                                    ? Colors.grey
                                    : i == 2
                                    ? Colors.brown
                                    : Colors.white,
                                width: 3.0,
                                style: BorderStyle.solid),
                            borderRadius:
                            BorderRadius.circular(5.0)),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 200.0,
                              height: 30.0,
                              alignment: Alignment.center,
                              child: Text(
                                "["+(_getDestinationItemIndex(index)+1).toString()+"/20] ",
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontSize: 20,
                                    color: Colors.redAccent
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                snapshot.data[_getDestinationItemIndex(index)].question,
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: snapshot.data[_getDestinationItemIndex(index)].image != ""
                                    ? Image.network(
                                  config.imageURL + snapshot.data[_getDestinationItemIndex(index)].image,
                                  width:
                                  snapshot.data[_getDestinationItemIndex(index)].image == "" ? 10 : 400,
                                  height:
                                  snapshot.data[_getDestinationItemIndex(index)].image == "" ? 10 : 350,
                                )
                                    : SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  snapshot.data[_getDestinationItemIndex(index)].answer,
                                  style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontSize: 20,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          }
        },
      ),
    );

}

Future<List<Question>> fetchAnswers() async {
  QuizController quizController = Get.put(QuizController());
  var url = config.testURL + '/quizzes/answers';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: convert.jsonEncode(<String, dynamic>{
      'previous_questions': quizController.previousQuizIds,
    }),
  );
  if (response.statusCode == 200) {
    var responseData = convert.jsonDecode(response.body);

    //Creating a list to store input data;
    List<Question> questions = [];

    if (responseData.length == 0) {
      return questions;
    }
    for(int x=0; x<responseData.length; x++){

      Question question = Question(
          question: responseData[x]["question"],
          image: responseData[x]["diagram"],
          answer: responseData[x]["answer"]);
      //Adding user to the list.
      questions.add(question);
    }
    return questions;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}}

class Question {
  final String question;
  final String image;
  final String answer;

  const Question({
    this.question,
    this.image,
    this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      image: json['image'],
      answer: json['answer'],
    );
  }
}
