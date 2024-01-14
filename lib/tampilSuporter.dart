import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pab_uas/auth/navbar.dart';
import 'drawer.dart';
import 'editSuporter.dart';

class Suporter {
  final String id;
  final String nama;
  final String alamat;
  final String? tglDaftar;
  final String? noTelp;
  final String? foto;

  Suporter({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.tglDaftar,
    required this.noTelp,
    required this.foto,
  });

  factory Suporter.fromJson(Map<String, dynamic> json) {
    return Suporter(
        id: json['id'],
        nama: json['nama'],
        alamat: json['alamat'],
        tglDaftar: json['tgl_daftar'],
        noTelp: json['no_telpon'],
        foto: json['foto']);
  }
}

void main() {
  runApp(DisplaySuporter());
}

class DisplaySuporter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: DisplaySuporterPage(),
      ),
    );
  }
}

class DisplaySuporterPage extends StatefulWidget {
  @override
  _DisplaySuporterPageState createState() => _DisplaySuporterPageState();
}
int _currentIndex = 1 ;

class _DisplaySuporterPageState extends State<DisplaySuporterPage> {
  late Future<List<Suporter>> _suporters;
  TextEditingController _searchController = TextEditingController();

  Future<List<Suporter>> fetchSuporters() async {
    final response = await http.get(
        Uri.parse('http://localhost/genap/suporter/suporterapi.php'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Suporter.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> _deleteSuporter(String id) async {
    try {
      var url =
          Uri.parse('http://localhost/genap/suporter/suporterdelete.php');
      var response = await http.post(
        url,
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        print('Book deleted successfully');
        setState(() {
          _suporters = fetchSuporters();
        });
      } else {
        print('Failed to delete book. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<List<Suporter>> _searchSuporters(String query) async {
    var allSuporters = await fetchSuporters();
    if (query.isEmpty) {
      return allSuporters;
    } else {
      return allSuporters
          .where((suporter) =>
              suporter.nama.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _suporters = fetchSuporters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Suporter'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Suporter Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _suporters = fetchSuporters();
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _suporters = _searchSuporters(value);
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Suporter>>(
              future: _suporters,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var suporter = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), // Sesuaikan nilai border radius sesuai keinginan
                        ),
                        child: ListTile(
                          leading: suporter.foto != null &&
                                  Uri.parse(
                                          'http://localhost/genap/suporter/${suporter.foto!}')
                                      .isAbsolute
                              ? Image.network(
                                  'http://localhost/genap/suporter/${suporter.foto!}',
                                  width: 50, // Adjust width as needed
                                  height: 50, // Adjust height as needed
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons
                                  .image), // Placeholder if no valid image URL is available
                          title: Text(suporter.nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Tanggal Daftar: ${suporter.tglDaftar ?? 'Not Available'}'),
                              Text('Alamat: ${suporter.alamat}'),
                              Text(
                                  'No. Telepon: ${suporter.noTelp ?? 'Not Available'}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  // Navigate to the edit page
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditSuporter(suporter),
                                    ),
                                  );

                                  // When returning from the edit page, refresh the data
                                  setState(() {
                                    _suporters = fetchSuporters();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteSuporter(suporter
                                      .id); // Function to delete the book
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/klub');
              break;
            case 1:
              Navigator.pushNamed(context, '/suporter');
              break;
          }
        },
      ),
    );
  }
}
