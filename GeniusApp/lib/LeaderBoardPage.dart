import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart' as config;
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'controllers/UserAccountController.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {

  int i = 0;
  Color my = Colors.brown,
      CheckMyColor = Colors.white;


  @override
  Widget build(BuildContext context) {

    var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);

    return Stack(
        children: <Widget>[
    Scaffold(
    body: Container(
        margin: EdgeInsets.only(top: 65.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Container(
    margin: EdgeInsets.only(left: 15.0, top: 10.0),
    child: RichText(
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
    ),
    Padding(
    padding: EdgeInsets.only(left: 15.0),
    child: Text(
    'Level Leader Board: ',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    ),
    Container(
    child: FutureBuilder(
    future: fetchLeaders(),
    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
    if (snapshot.data == null) {
    return Container(
    child: Center(
    child: CircularProgressIndicator(),
    ),
    );
    }
    else {

    return ListView.separated(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    padding: const EdgeInsets.all(8),
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext context, int index) {
    print(index);
    if (index >= 1) {
    print('Greater than 1');
    if (snapshot.data[index].points ==
    snapshot.data[index - 1].points) {
    print('Same');
    } else {
    i++;
    }
    }
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
    children: <Widget>[
    Row(
    children: <Widget>[
    Padding(
    padding: const EdgeInsets.only(
    top: 10.0, left: 15.0),
    child: Row(
    children: <Widget>[
    ],
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(
    left: 20.0, top: 10.0),
    child: Column(
    mainAxisAlignment:
    MainAxisAlignment.center,
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: <Widget>[
    Container(
    alignment: Alignment
        .centerLeft,
    child: Text(
    snapshot
        .data[index].name,
    style: TextStyle(
    color: Colors
        .deepPurple,
    fontWeight:
    FontWeight
        .w500),
    maxLines: 6,
    )),
    Text("Points: " +
    snapshot
        .data
        [index].points
        .toString()),
    ],
    ),
    ),
    Flexible(child: Container()),
    i == 0
    ? Text("🥇", style: r)
        : i == 1
    ? Text(
    "🥈",
    style: r,
    )
        : i == 2
    ? Text(
    "🥉",
    style: r,
    )
        : Text(''),
    Padding(
    padding: EdgeInsets.only(
    left: 20.0,
    top: 13.0,
    right: 20.0),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    );

    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
    }
  }

  ,
  ),
  )
  ])
  )
  )
  ],
  );
}

Future<List<LeaderBoardUser>> fetchLeaders() async {
  UserAccountController userAccountController = Get.put(UserAccountController());

  var url = config.serverURL + '/leaderboard/'+userAccountController.level.toString();
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var responseData = convert.jsonDecode(response.body);
    //   var responseData = json.decode(response.body);
    //Creating a list to store input data;
    List<LeaderBoardUser> users = [];
    for (var singleUser in responseData) {
      LeaderBoardUser user = LeaderBoardUser(name: singleUser["username"],
          points: singleUser["points"].toString(),
          level: singleUser["category_id"].toString());
      //Adding user to the list.
      users.add(user);
    }
    return users;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}}

class LeaderBoardUser {
  final String name;
  final String points;
  final String level;

  const LeaderBoardUser({
    this.name,
    this.points,
    this.level
  });

  factory LeaderBoardUser.fromJson(Map<String, dynamic> json) {
    return LeaderBoardUser(
      name: json['name'],
      points: json['points'],
      level: json['level'],
    );
  }
}