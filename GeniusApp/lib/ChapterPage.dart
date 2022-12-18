
import 'package:flutter/material.dart';
import 'LessonPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'config.dart' as config;
import 'package:get/get.dart';
import 'controllers/QuizController.dart';
// TODO: Import ad_helper.dart
import 'utils/AdHelper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChapterPage extends StatefulWidget {
  @override
  _ChapterPageState createState() => _ChapterPageState();

}
class Subject {
  final int id;
  final String name;

  const Subject({
     this.id,
     this.name,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
    );
  }
}
class _ChapterPageState extends State<ChapterPage> {

  final List<Color> colorCodes = <Color>[Colors.greenAccent, Colors.redAccent, Colors.blueAccent];

  List<Subject> futureSubjects;

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
  // TODO: Add _kAdIndex
  static final _kAdIndex = 1;

// TODO: Add _getDestinationItemIndex()
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _bannerAd != null) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  Future<List<Subject>> fetchSubjects() async{
    QuizController  quizController= Get.put(QuizController());
    var url = config.testURL+'/grades/'+quizController.gradeId.toString()+'/subjects';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseData = convert.jsonDecode(response.body);
   //   var responseData = json.decode(response.body);

      //Creating a list to store input data;
      List<Subject> subjects = [];
      for (var singleUser in responseData) {
        Subject subject = Subject(
            id: singleUser["id"],
            name: singleUser["name"]);
        //Adding user to the list.
        subjects.add(subject);
      }
      return subjects;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
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
    QuizController  quizController= Get.put(QuizController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {  Navigator.pop(context); },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
          title: Text("Select Subject"),
          backgroundColor: Colors.blueAccent,
        ),

        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            Container(
              height:MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Container(
              child: FutureBuilder(
                future: fetchSubjects(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }else
                  if (snapshot.data.length == 0) {
                    return Card(
                      color: Colors.white,
                      borderOnForeground: true,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text("Empty List",style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: MediaQuery.of(context).size.height / 40,
                            )),
                            subtitle: Text("Please Exercise patience as our team are adding more questions"),
                          ),
                          ElevatedButton(
                            style: raisedButtonStyle,
                            onPressed: () async{
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Go Back",
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
                    return ListView(
                        children: <Widget>[
                          Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                              ),
                              child:ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                itemCount: snapshot.data.length+ (_bannerAd != null ? 1 : 0),
                                itemBuilder: (BuildContext context, int index) {
                                // TODO: Render a banner ad
                                if (_bannerAd != null && index == 0) {
                                return Container(
                                width: _bannerAd.size.width.toDouble(),
                                height: 72.0,
                                alignment: Alignment.center,
                                child: AdWidget(ad: _bannerAd),
                                );
                                }else {
                                  return GestureDetector(
                                    onTap: () {
                                      quizController.subjectId =
                                          snapshot.data[_getDestinationItemIndex(index)].id;
                                      quizController.subjectName =
                                          snapshot.data[_getDestinationItemIndex(index)].name;
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => LessonPage()));
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      borderOnForeground: true,
                                      elevation: 10,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            // title: Text("${phoneNumber[index]}",style: TextStyle(
                                            title: Text(
                                                snapshot.data[_getDestinationItemIndex(index)].name,
                                                style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontSize: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height / 40,
                                                )),
                                            //    subtitle: Text("You will learn about ${callType[index]}"),
                                            subtitle: Text(
                                                "You will learn about " +
                                                    snapshot.data[_getDestinationItemIndex(index)].name),
                                          ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.end,
                                          //   children: <Widget>[
                                          //     TextButton(
                                          //       child: const Text('Dail'),
                                          //       onPressed: () {/* ... */},
                                          //     ),
                                          //     const SizedBox(width: 8),
                                          //     TextButton(
                                          //       child: const Text('Call History'),
                                          //       onPressed: () {/* ... */},
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                              )
                          )
                        ]
                    );
                  }
                },
              ),
            )],
        ),
      ),
    ) ;
  }
}
