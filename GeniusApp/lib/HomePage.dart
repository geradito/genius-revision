
import 'package:flutter/material.dart';
import 'ChapterPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  static const String _title = 'DNL Book App';
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final List<Color> colorCodes = <Color>[Colors.greenAccent, Colors.redAccent, Colors.blueAccent];
  final List<String> phoneNumber = <String>[
    'Grade One',
    'Grade Two',
    'Grade Three',
    'Grade Four',
    'Grade Five',
    'Grade Six',
    'Grade Seven'
  ];
  final List<String> callType = <String>[
    "one 1",
    "two 2",
    "three 3",
    "four 4",
    "five 5",
    "six 6",
    "seven 7"
  ];

  @override
  Widget build(BuildContext context) {
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
                child: ListView(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Select a Chapter',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )),
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child:ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: phoneNumber.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        //signup screen
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
                              title: Text("${phoneNumber[index]}",style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: MediaQuery.of(context).size.height / 40,
                              )),
                              subtitle: Text("You will learn about ${callType[index]}"),
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
                ))
          ],
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
