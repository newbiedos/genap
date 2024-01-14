import 'displayKlub.dart';
import 'tambahKlub.dart';
import 'tambahSuporter.dart';
import 'tampilSuporter.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Your image network widget goes here
                ClipOval(
                  child: Image.network(
                    'assets/hantu.jpg',
                    width: 90.0, // Set the width as needed
                    height: 90.0, // Set the height as needed
                    fit: BoxFit.cover, // Adjust the fit as needed
                  ),
                ),
                const SizedBox(
                    width: 10.0), // Add some spacing between image and text
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dimas Ryansyah',
                      style: TextStyle(
                        height: 1.0,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '1462100210',
                      style: TextStyle(
                        height: 1.0,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Klub'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddKlubPage()),
              );
            },
          ),
          ListTile(
            title: Text('Suporter'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddSuporterPage()),
              );
            },
          ),
          ListTile(
            title: Text('Laporan Klub'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplayKlubPage()),
              );
            },
          ),
          ListTile(
            title: Text('Laporan Suporter'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplaySuporterPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
