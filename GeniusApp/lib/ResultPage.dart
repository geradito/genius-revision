import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'LoginPage.dart';
import 'controllers/QuizController.dart';
import 'controllers/UserAccountController.dart';

// TODO: Import ad_helper.dart
import 'utils/AdHelper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPage createState() => _ResultPage();

}

const int maxFailedLoadAttempts = 3;
class _ResultPage extends State<ResultPage> {
  QuizController  quizController= Get.put(QuizController());
  UserAccountController userAccountController = Get.put(UserAccountController());

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.purple,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold)
  );

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                      Opacity(opacity: quizController.score<15?0.0:1.0,
                      child:Image.asset('assets/imgs/trophy.png'),),
                      Text(quizController.score<15? "You Can Improve":"Congratulations!", style: TextStyle(
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
                      ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: (){
                          quizController.resetScore();
                          quizController.resetPreviousQuizIds();
                          _showInterstitialAd();

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


  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  // TODO: Implement _loadInterstitialAd()
  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          LoginPage()), (Route<dynamic> route) => false);
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginPage()), (Route<dynamic> route) => false);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

}
