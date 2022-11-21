
import 'package:flutter/material.dart';
import 'LessonPage.dart';
import 'LessonTwoPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'config.dart' as config;
import 'package:get/get.dart';
import 'controllers/QuizController.dart';

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
  static const String _title = 'DNL Book App';

  final List<Color> colorCodes = <Color>[Colors.greenAccent, Colors.redAccent, Colors.blueAccent];

  List<Subject> futureSubjects;

  Future<List<Subject>> fetchSubjects() async{
    QuizController  quizController= Get.put(QuizController());
    var url = config.testURL+'/grades/'+quizController.gradeId.toString()+'/subjects';
    final response = await http.get(url);
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

        resizeToAvoidBottomPadding: false,
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
                  } else {
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
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                        quizController.subjectId = snapshot.data[index].id;
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LessonPage()));
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
                                            title: Text(snapshot.data[index].name,style: TextStyle(
                                              letterSpacing: 1.5,
                                              fontSize: MediaQuery.of(context).size.height / 40,
                                            )),
                                            //    subtitle: Text("You will learn about ${callType[index]}"),
                                            subtitle: Text("You will learn about "+snapshot.data[index].name),
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
    // return MaterialApp(
    //   title: _title,
    //   home: Scaffold(
    //     appBar: AppBar(title: const Text(_title)),
    //     body: const MyStatefulWidget(),
    //   ),
    // );
  }
}
