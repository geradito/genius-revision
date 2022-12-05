import 'package:dnlbook/LoginPage.dart';
import 'package:dnlbook/controllers/UserAccountController.dart';
import 'package:flutter/material.dart';
import 'config.dart' as config;
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'models/LevelModel.dart';
import 'utils/DatabaseHelper.dart';
import 'models/UserModel.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget{
  @override
  _SignUpPageState createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpPage> {

  String email, password;
  DateTime _selectedDate= DateTime.now();
  DatabaseHelper helper = DatabaseHelper();
  int dropdownvalue;

  Future<List<Level>> fetchLevels() async{
    UserAccountController userAccountController = Get.put(UserAccountController());

    var url = config.testURL+'/categories';
    final response = await http.get(url);
    List<Level> levels = [];
    if (response.statusCode == 200) {
      var responseData = convert.jsonDecode(response.body);
      //Creating a list to store input data;
      for (var data in responseData) {
        Level level = Level(
            id: data["id"],
            name: data["name"]);
        //Adding user to the list.
        levels.add(level);
      }
    }
    return levels;
  }

  Widget _buildLogo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
        ),
        Text(
          'Genius Revision',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height/30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildEmailRow(){
    UserAccountController userAccountController = Get.put(UserAccountController());
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        maxLength: 10,
        keyboardType: TextInputType.text,
        onChanged: (value){
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

  Widget _buildPasswordRow(){

    UserAccountController userAccountController = Get.put(UserAccountController());
    // List of items in our dropdown menu
    return  FutureBuilder<List<Level>>(
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
                print("Selected city is "+newVal.toString());
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

Widget _buildLoginButton(){
  UserAccountController userAccountController = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            height: 1.4 * (MediaQuery.of(context).size.height/20),
            width: 5 * (MediaQuery.of(context).size.width/10),
            margin: EdgeInsets.only(bottom: 20),
            child: Hero(
              tag:'dash',
              child: RaisedButton(
                elevation: 5.0,
                color: Colors.pink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
                onPressed: () async{
                  User user= new User(userAccountController.username, userAccountController.level, 2);
                  int result = await helper.insertUser(user);
                  if (result != 0) {  // Success
                    _showAlertDialog('Status', 'User Saved Successfully');
                  } else {  // Failure
                    _showAlertDialog('Status', 'Problem Saving User');
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.height / 40,
                  ),
                ),
              ),
            )
        )
      ],
    );
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  Widget _buildContainer(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
              Radius.circular(20)
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
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
                        fontSize: MediaQuery.of(context).size.height/30,
                      ),
                    ),
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                SizedBox(height: 20,),
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
                _buildLogo(),
                _buildContainer(),
              ],
            )
          ],
        ),
      ),
    ) ;
  }
}