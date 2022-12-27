import 'package:QuizHQ/AnswerPage.dart';

import 'utils/DatabaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'ResultPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'config.dart' as config;
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'controllers/QuizController.dart';
import 'controllers/UserAccountController.dart';
import 'models/UserModel.dart';

// TODO: Import ad_helper.dart
import 'utils/AdHelper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LessonPage extends StatefulWidget {
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

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const String testDevice = null;

class _LessonPage extends State<LessonPage> {
  List<Question> futureGrades;
  final player = AudioPlayer();

  // TODO: Add _bannerAd
  BannerAd _bannerAd;
  BannerAd _mediumBannerAd;

  RewardedAd _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  //Creating a list to store input data;
  Future<List<Question>> questions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    questions = fetchQuestions();
    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.largeBanner,
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

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _mediumBannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    _createRewardedAd();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();
    _mediumBannerAd?.dispose();
    _rewardedAd?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<List<Question>> fetchQuestions() async {
    QuizController quizController = Get.put(QuizController());
    var url = config.testURL + '/quizzes';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, dynamic>{
        'previous_questions': quizController.previousQuizIds,
        'subject_id': quizController.subjectId,
      }),
    );
    if (response.statusCode == 200) {
      var responseData = convert.jsonDecode(response.body);

      //Creating a list to store input data;
      List<Question> questions = [];

      if (responseData.length == 0) {
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

  void updateUserPoints(int points) async {
    UserAccountController userAccountController = Get.find();

    DatabaseHelper databaseHelper = DatabaseHelper();
    User user = new User.withId(
        userAccountController.userId,
        userAccountController.username,
        userAccountController.level,
        userAccountController.points);
    int result = await databaseHelper.updateUser(user);
    if (result != 0) {
      // Success
      // _showAlertDialog('Status', 'You have earned $points');
    } else {
      // Failure
      // _showAlertDialog('Status', 'Problem Saving User');
    }
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.purple,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));

  @override
  Widget build(BuildContext context) {
    QuizController quizController = Get.put(QuizController());
    UserAccountController userAccountController =
        Get.put(UserAccountController());

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            quizController.resetScore();
            quizController.resetPreviousQuizIds();
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: Text(quizController.subjectName),
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
          } else if (snapshot.data.length == 0) {
            if (quizController.score < 1) {
              newPoints = 0;
            } else if (quizController.score > 0 && quizController.score <= 4) {
              newPoints = 1;
            } else if (quizController.score >= 5 && quizController.score <= 8) {
              newPoints = 2;
            } else if (quizController.score >= 9 &&
                quizController.score <= 12) {
              newPoints = 3;
            } else if (quizController.score >= 13 &&
                quizController.score <= 16) {
              newPoints = 4;
            } else if (quizController.score >= 17 &&
                quizController.score <= 20) {
              newPoints = 5;
            }

            userAccountController.increasePoints(newPoints);
            updateUserPoints(newPoints);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'The End',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "You have earned $newPoints point(s).",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Let's view your results.",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultPage()));
                      },
                      child: Text(
                        "View Results",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: MediaQuery.of(context).size.height / 40,
                        ),
                      ),
                    )),
                // TODO: Display a banner when ready
                if (_mediumBannerAd != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: _mediumBannerAd.size.width.toDouble(),
                      height: _mediumBannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _mediumBannerAd),
                    ),
                  ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.play_circle_fill),
                        iconColor: Colors.red,
                        title: Text('Watch a Video?'),
                        subtitle: Text(
                            'Would you like to watch a video for 1 more point?'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: const Text('Watch Video'),
                            onPressed: () {
                              _showRewardedAd();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.play_circle_fill),
                        iconColor: Colors.red,
                        title: Text('View Answers?'),
                        subtitle: Text(
                            'Would you like to watch a video to view answers?'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: const Text('Watch Video'),
                            onPressed: () {
                            //  _showRewardedAdAnswers();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AnswerPage()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return ListView(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 200.0,
                        height: 30.0,
                        alignment: Alignment.center,
                        child: Text(
                          "[" +
                              (quizController.previousQuizIds.length + 1)
                                  .toString() +
                              "/20] ",
                          style: TextStyle(
                            letterSpacing: 1.5,
                            fontSize: 20,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
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
                          child: snapshot.data[0].image != ""
                              ? Image.network(
                                  config.imageURL + snapshot.data[0].image,
                                  width:
                                      snapshot.data[0].image == "" ? 10 : 400,
                                  height:
                                      snapshot.data[0].image == "" ? 10 : 350,
                                )
                              : SizedBox()),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () async {
                            if (snapshot.data[0].optionA ==
                                snapshot.data[0].answer) {
                              quizController.increaseScore();
                            }
                            quizController.previousQuizIds
                                .add(snapshot.data[0].id);
                            player.setAsset(snapshot.data[0].optionA ==
                                snapshot.data[0].answer
                                ? "assets/sounds/correct.mp3"
                                : "assets/sounds/wrong.mp3");
                            player.play();

                            snapshot.data[0].optionA ==
                                snapshot.data[0].answer
                                ? _successSweetAlert()
                                : _failSweetAlert();
                          },
                          child: Text(
                            snapshot.data[0].optionA,
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize:
                              MediaQuery.of(context).size.height / 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () {
                            if (snapshot.data[0].optionB ==
                                snapshot.data[0].answer) {
                              quizController.increaseScore();
                            }
                            quizController.previousQuizIds
                                .add(snapshot.data[0].id);
                            player.setAsset(snapshot.data[0].optionB ==
                                snapshot.data[0].answer
                                ? "assets/sounds/correct.mp3"
                                : "assets/sounds/wrong.mp3");
                            player.play();

                            snapshot.data[0].optionB ==
                                snapshot.data[0].answer
                                ? _successSweetAlert()
                                : _failSweetAlert();
                          },
                          child: Text(
                            snapshot.data[0].optionB,
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize:
                              MediaQuery.of(context).size.height / 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () {
                            if (snapshot.data[0].optionC ==
                                snapshot.data[0].answer) {
                              quizController.increaseScore();
                            }
                            quizController.previousQuizIds
                                .add(snapshot.data[0].id);
                            player.setAsset(snapshot.data[0].optionC ==
                                snapshot.data[0].answer
                                ? "assets/sounds/correct.mp3"
                                : "assets/sounds/wrong.mp3");
                            player.play();

                            snapshot.data[0].optionC ==
                                snapshot.data[0].answer
                                ? _successSweetAlert()
                                : _failSweetAlert();
                          },
                          child: Text(
                            snapshot.data[0].optionC,
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize:
                              MediaQuery.of(context).size.height / 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () {
                            if (snapshot.data[0].optionD ==
                                snapshot.data[0].answer) {
                              quizController.increaseScore();
                            }
                            quizController.previousQuizIds
                                .add(snapshot.data[0].id);
                            player.setAsset(snapshot.data[0].optionD ==
                                snapshot.data[0].answer
                                ? "assets/sounds/correct.mp3"
                                : "assets/sounds/wrong.mp3");
                            player.play();

                            snapshot.data[0].optionD ==
                                snapshot.data[0].answer
                                ? _successSweetAlert()
                                : _failSweetAlert();
                          },
                          child: Text(
                            snapshot.data[0].optionD,
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize:
                              MediaQuery.of(context).size.height / 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // TODO: Display a banner when ready
                    if (_bannerAd != null)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: _bannerAd.size.width.toDouble(),
                          height: _bannerAd.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd),
                        ),
                      ),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _successSweetAlert() async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "Correct Answer",
        ));
    if (response == null || response.isTapConfirmButton) {
      // Unload audio and release decoders until needed again.
      player.stop();
      // Permanently release decoders/resources used by the player.
      player.dispose();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LessonPage(),
        ),
      );
    }
  }

  void _failSweetAlert() async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.danger,
          title: "Wrong answer",
        ));

    if (response == null || response.isTapConfirmButton) {
      // Unload audio and release decoders until needed again.
      player.stop();
      // Permanently release decoders/resources used by the player.
      player.dispose();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LessonPage(),
        ),
      );
    }
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd.setImmersiveMode(true);
    _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      UserAccountController userAccountController =
          Get.put(UserAccountController());
      userAccountController.increasePoints(1);
      updateUserPoints(1);
      _showAlertDialog(
          "1 point awarded", "Your earned points will reflect on home page");
    });
    _rewardedAd = null;
  }

  void _showRewardedAdAnswers() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd.setImmersiveMode(true);
    _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnswerPage()));
    });
    _rewardedAd = null;
  }
}
