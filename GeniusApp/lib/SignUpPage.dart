import 'LoginPage.dart';
import 'controllers/UserAccountController.dart';
import 'package:flutter/material.dart';
import 'config.dart' as config;
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'models/LevelModel.dart';
import 'utils/DatabaseHelper.dart';
import 'models/UserModel.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:art_sweetalert/art_sweetalert.dart';

// TODO: Import ad_helper.dart
import 'utils/AdHelper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email, password;
  DateTime _selectedDate = DateTime.now();
  DatabaseHelper helper = DatabaseHelper();
  int dropdownvalue;
  Random random = new Random();

  // TODO: Add _bannerAd
  BannerAd _bannerAd;
  BannerAd _bannerAd2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd2 = ad as BannerAd;
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
    _bannerAd2?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<List<Level>> fetchLevels() async {
    UserAccountController userAccountController =
        Get.put(UserAccountController());

    var url = config.testURL + '/categories';
    final response = await http.get(Uri.parse(url));
    List<Level> levels = [];
    if (response.statusCode == 200) {
      var responseData = convert.jsonDecode(response.body);
      //Creating a list to store input data;
      for (var data in responseData) {
        Level level = Level(id: data["id"], name: data["name"]);
        //Adding user to the list.
        levels.add(level);
      }
    }
    return levels;
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
        ),
        RichText(
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
                          color: Colors.pink,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold))
                ])),
      ],
    );
  }

  Widget _buildEmailRow() {
    UserAccountController userAccountController =
        Get.put(UserAccountController());
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        maxLength: 8,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          // setState(() {
          //   email = value;
          // });
          userAccountController.username = value;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.cyan,
          ),
          labelText: 'Username',
        ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    UserAccountController userAccountController =
        Get.put(UserAccountController());
    // List of items in our dropdown menu
    return FutureBuilder<List<Level>>(
      future: fetchLevels(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return DropdownButton<int>(
            // Initial Value
            value: dropdownvalue,
            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: Text('Choose option'),

            // Array list of items
            items: data.map((Level item) {
              return DropdownMenuItem(
                value: item.id,
                child: Text(item.name),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (int newVal) {
              setState(() {
                print("Selected city is " + newVal.toString());
                dropdownvalue = newVal;
                userAccountController.level = dropdownvalue;
              });
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.purple,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
  Widget _buildLoginButton() {
    UserAccountController userAccountController = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 15),
          margin: EdgeInsets.only(bottom: 20),
          child: Hero(
            tag: 'dash',
            child: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () async {
                if (userAccountController.username == null ||
                    userAccountController.level == null) {
                  _showAlertDialog(
                      'Status', 'Username and option are required');
                } else {

                  User user = new User(userAccountController.username+random.nextInt(100).toString(),
                      userAccountController.level, 2);
                  int result = await helper.insertUser(user);
                  if (result != 0) {
                    // Success
                    _successSweetAlert(user.name);
                  } else {
                    // Failure
                    _showAlertDialog('Status', 'Problem Saving User');
                  }
                }
              },
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _successSweetAlert(username) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "$username Saved Successfully",
          text: "We have added some digits to your name to make it unique and you have been awarded 2 points"
        ));
    if (response == null || response.isTapConfirmButton) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }
  Widget _buildContainer() {
    return Row(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    ),
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                SizedBox(
                  height: 20,
                ),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    color: Colors.blueAccent,
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
                _buildLogo(),
                _buildContainer(),
                if (_bannerAd2 != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: _bannerAd2.size.width.toDouble(),
                      height: _bannerAd2.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd2),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
