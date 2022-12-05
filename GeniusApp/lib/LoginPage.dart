
import 'package:flutter/material.dart';
import 'SignUpPage.dart';
import 'HomePage.dart';
import 'package:get/get.dart';
import 'controllers/UserAccountController.dart';
import 'utils/DatabaseHelper.dart';
import 'models/UserModel.dart';
import 'package:sqflite/sqflite.dart';

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

  @override
  Widget build(BuildContext context) {
    if (userList == null) {
      userList = List<User>();
      updateListView();
    }
    UserAccountController userAccountController = Get.put(UserAccountController());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Genius Revision',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
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
                            height: MediaQuery.of(context).size.height * 0.6,
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
                                  RaisedButton(
                                    elevation: 5.0,
                                    color: Colors.red[this.userList[index].level*200],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)
                                    ),
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
                        'Sign up',
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
                ],
            ),

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
