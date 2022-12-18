
import 'package:flutter/material.dart';
import 'SignUpPage.dart';
import 'HomePage.dart';
import 'package:get/get.dart';
import 'controllers/UserAccountController.dart';
import 'utils/DatabaseHelper.dart';
import 'models/UserModel.dart';
import 'package:sqflite/sqflite.dart';

// TODO: Import ad_helper.dart
import 'utils/AdHelper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<User> userList;
  int count = 0;

  final List<Color> colorCodes = <Color>[Colors.greenAccent, Colors.redAccent, Colors.blueAccent];


// TODO: Add _bannerAd
  BannerAd _bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener:
      BannerAdListener(
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
      primary: Colors.purple,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold)
  );
  @override
  Widget build(BuildContext context) {
    if (userList == null) {
      userList = List<User>();
      updateListView();
    }
    UserAccountController userAccountController = Get.put(UserAccountController());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            Container(
              height:MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(70),
                      bottomRight: const Radius.circular(70),
                    )
                ),
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
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Genius Revision',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(20)
                        ),
                        child:Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child:

                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: count,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 50,
                                  child: Center(child:
                                  ElevatedButton(
                                   style: raisedButtonStyle,
                                    onPressed: (){
                                      userAccountController.userId = this.userList[index].id;
                                      userAccountController.username = this.userList[index].name;
                                      userAccountController.level = this.userList[index].level;
                                      userAccountController.points = this.userList[index].points;
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                    },
                                    child: Text(
                                      this.userList[index].name+' - '+this.userList[index].points.toString()+'pts',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: MediaQuery.of(context).size.height / 40,
                                      ),
                                    ),
                                  )),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                            )
                        )),
                  ],),
                Row(
                  children: <Widget>[
                    const Text('Do not have an account?'),
                    TextButton(
                      child: const Text(
                        'Sign Up Here',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signup screen
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
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
    ) ;
  }
}
