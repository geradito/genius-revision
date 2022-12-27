import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//void main() => runApp(MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: LoginPage(),
    );
  }
}
