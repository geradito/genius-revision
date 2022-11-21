
import 'package:flutter/material.dart';
import 'ChapterPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'config.dart' as config;
import 'package:get/get.dart';
import 'controllers/UserAccountController.dart';
import 'controllers/QuizController.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class Grade {
  final int id;
  final String name;

  const Grade({
    this.id,
    this.name,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      name: json['name'],
    );
  }
}
class _HomePageState extends State<HomePage> {
  static const String _title = config.currentCategoryName;

  List<Grade> futureGrades;

  Future<List<Grade>> fetchGrades() async{
    UserAccountController userAccountController = Get.put(UserAccountController());

    var url = config.testURL+'/categories/'+userAccountController.level.toString()+'/grades';
    final response = await http.get(url);
    List<Grade> grades = [];
    if (response.statusCode == 200) {
      var responseData = convert.jsonDecode(response.body);
      //Creating a list to store input data;
      for (var data in responseData) {
        Grade grade = Grade(
            id: data["id"],
            name: data["name"]);
        //Adding user to the list.
        grades.add(grade);
      }
    }
    return grades;
  }

  @override
  Widget build(BuildContext context) {
    QuizController quizController = Get.put(QuizController());
    return SafeArea(
      child: Scaffold(
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
                future: fetchGrades(),
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
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    _title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30),
                                  )),
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child:ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                //signup screen
                                quizController.gradeId = snapshot.data[index].id;
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChapterPage()));
                              },
                              child: Card(
                                color: Colors.white,
                                borderOnForeground: true,
                                elevation: 10,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(snapshot.data[index].name,style: TextStyle(
                                        letterSpacing: 1.5,
                                        fontSize: MediaQuery.of(context).size.height / 40,
                                      )),
                                      subtitle: Text("Genius: Gerald, Prev: Musialike" /*${snapshot.data[index].name}"*/),
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
