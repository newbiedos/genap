import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      // Clear SharedPreferences

      // Navigate to login page
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
       appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 246, 245),
        automaticallyImplyLeading: false,
      ),
     backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                child: Image.asset('assets/untag.png'), // Replace 'your_image.png' with your image asset
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
            Text(
              'FAKULTAS TEKNIK',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'PRODI TEKNIK INFORMATIKA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
             Text(
                'UNIVERSITAS 17 AGUSTUS 1945 SURABAYA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
             Text(
              '2023',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data in SharedPreferences
  }
}
