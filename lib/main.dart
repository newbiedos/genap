import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pab_uas/auth/login.dart';
import 'package:pab_uas/auth/splashscren.dart';
import 'package:pab_uas/tampilSuporter.dart';
import 'displayKlub.dart';

import 'drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: createMaterialColor(
          Color.fromARGB(255, 205, 255, 106),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 187, 187, 173),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
     debugShowCheckedModeBanner: false,
      home : SplashScreen(),// Change the initial route to '/login'
      routes: {
        '/login': (context) => Login(),
        '/beranda': (context) => DisplayKlubPage(),
        '/suporter': (context) => DisplaySuporterPage(),
        '/klub': (context) => DisplayKlubPage(),

      },
  
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, Color> swatch = <int, Color>{};
  final int primary = color.value;
  for (int i = 0; i < 10; i++) {
    final int strength = strengths[i];
    final double blend = i / 10.0;
    swatch[strength] = Color.lerp(Colors.white, color, blend)!;
  }
  return MaterialColor(primary, swatch);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {                    
    return Scaffold(
      key: _scaffoldKey,

      drawer: AppDrawer(), // Use the AppDrawer widget
    );
  }
}
