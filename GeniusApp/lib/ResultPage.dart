import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'LoginPage.dart';
import 'controllers/QuizController.dart';
import 'controllers/UserAccountController.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:io';

// TODO: Import ad_helper.dart
import 'utils/AdHelper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'config.dart' as config;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPage createState() => _ResultPage();
}

const int maxFailedLoadAttempts = 3;

class _ResultPage extends State<ResultPage> {
  QuizController quizController = Get.put(QuizController());
  UserAccountController userAccountController =
  Get.put(UserAccountController());

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.purple,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  File _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
    initPlatformState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
        controller: screenshotController,
        child:
      SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xfff2f3f7),
          body: Stack(
            children: <Widget>[
              Container(
                child: Center(
                    child: Column(
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "Quiz",
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: "HQ",
                                      style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold))
                                ])),
                        Opacity(
                          opacity: quizController.score < 15 ? 0.0 : 1.0,
                          child: Image.asset('assets/imgs/trophy.png'),
                        ),
                        Text(
                            quizController.score < 15
                                ? "You Can Improve"
                                : "Congratulations!",
                            style: TextStyle(
                                fontSize: 40,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4
                                  ..color = Colors.cyan)),
                        Text(userAccountController.username,
                            style: TextStyle(
                                fontSize: 30,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.cyan)),
                        Text(
                          "Your Score is " +
                              quizController.score.toString() +
                              " out of " +
                              quizController.previousQuizIds.length.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () {
                            quizController.resetScore();
                            quizController.resetPreviousQuizIds();
                            uploadPointsToServer();
                            _showInterstitialAd();
                          },
                          child: Text(
                            "Finish",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 40,
                            ),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),  floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _takeScreenshotandShare();
          },
          tooltip: 'Increment',
          child: Icon(Icons.share),
        ),
        ))
    );
  }

  _takeScreenshotandShare() async {
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });
      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");
      await Share.file('Anupam', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
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

  Future<void> uploadPointsToServer() async {
    var url = config.testURL + '/leaderboard/save';
    String requestData = getJsonData();
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestData,
    );
    if (response.statusCode == 201) {
      var responseData = convert.jsonDecode(response.body);

      print('Success with status: ${response.statusCode}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> initPlatformState() async {
    _deviceData =
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    Map<String, dynamic> deviceData =  <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
    setState(() {
      _deviceData = deviceData;
    });
    return deviceData;
  }

  String getJsonData() {
    return convert.jsonEncode(<String, dynamic>{
      'device_finger_print': _deviceData['fingerprint'],
      'device_id': _deviceData['id'],
      'android_id': _deviceData['androidId'],
      'username': userAccountController.username,
      'points': userAccountController.points,
      'level': userAccountController.level,
    });
  }

}
