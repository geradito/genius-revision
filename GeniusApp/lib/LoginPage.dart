import 'package:QuizHQ/utils/HexColor.dart';
import 'package:flutter/material.dart';
import 'SignUpPage.dart';
import 'HomePage.dart';
import 'package:get/get.dart';
import 'controllers/UserAccountController.dart';
import 'utils/DatabaseHelper.dart';
import 'models/UserModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

// TODO: Import ad_helper.dart
import 'utils/AdHelper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  List<User> userList;
  int count = 0;


// TODO: Add _bannerAd
  BannerAd _bannerAd;
  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.generalBannerAdUnitId,
      request: AdRequest(),
      size: AdSize.fullBanner,
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

  void updateListView() {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<User>> userListFuture = databaseHelper.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.userList = userList;
          this.count = userList.length;
        });
      });
    });
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: HexColor("#1AA7EC"),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
  @override
  Widget build(BuildContext context) {
    if (userList == null) {
      userList = List<User>();
      updateListView();
    }
    UserAccountController userAccountController =
        Get.put(UserAccountController());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("#1AA7EC"),
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(70),
                      bottomRight: const Radius.circular(70),
                    )),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 1.0),

                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                        child: Image.asset('assets/imgs/trophy.png')),
                  ),
                ),
                Container(
                    child: RichText(
                        text: TextSpan(
                            text: "Quiz",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: "HQ",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold))
                            ]))),
                TextButton(
                  child: const Text(
                    'Sign Up Here',
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpPage()));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: count,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 50,
                                  child: Center(
                                      child: ElevatedButton(
                                        style: raisedButtonStyle,
                                        onPressed: () {
                                          userAccountController.userId =
                                              this.userList[index].id;
                                          userAccountController.username =
                                              this.userList[index].name;
                                          userAccountController.level =
                                              this.userList[index].level;
                                          userAccountController.points =
                                              this.userList[index].points;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                        },
                                        child: Text(
                                          this.userList[index].name +
                                              ' - ' +
                                              this
                                                  .userList[index]
                                                  .points
                                                  .toString() +
                                              'pts',
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize:
                                            MediaQuery.of(context).size.height /
                                                40,
                                          ),
                                        ),
                                      )),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                              const Divider(),
                            ))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CircularButton(
                        color: Colors.red,
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.star_rate,
                          color: Colors.white,
                        ),
                        onClick: () {
                          print('Rate Button');
                          _launchRateURL();
                        }
                      ),
                    ),
                    Expanded(
                      child: CircularButton(
                        color: Colors.black,
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.question_mark,
                          color: Colors.white,
                        ),
                        onClick: (){
                          print('About Button');
                          _launchAboutURL();
                        },
                      ),
                    ),
                    Expanded(
                      child: CircularButton(
                        color: Colors.orange,
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.feedback,
                          color: Colors.white,
                        ),
                        onClick: (){
                          print('Feedback Button');
                          _launchFeedbackURL();
                        },
                      ),
                    ),
                    Expanded(
                      child: CircularButton(
                        color: Colors.green,
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onClick: (){
                          print('Share Button');
                          _shareAppLink();
                        },
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
            ),
          ],
        ),
        ),

    );
  }

  _shareAppLink()  {
     Share.text('', 'https://enrollzambia.com', 'text/plain');
     print("shared");
  }

}

void _launchRateURL() async {
  const url = 'https://play.google.com/store/apps/details?id=com.enrollzambia.quizhq';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
void _launchAboutURL() async {
  const url = 'https://quizhq.enrollzambia.com/about/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
void _launchFeedbackURL() async {
  const url = 'https://enrollzambia.com/geraldchinyama/contact.php';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class CircularButton extends StatelessWidget {

  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton({this.color, this.width, this.height, this.icon, this.onClick});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color,shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon,enableFeedback: true, onPressed: onClick),
    );
  }
}
