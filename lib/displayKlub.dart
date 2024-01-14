import 'dart:async';
import 'dart:convert';
import 'package:pab_uas/tambahKlub.dart';
import 'editKlub.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'drawer.dart';
import 'package:pab_uas/auth/navbar.dart';


//import 'editklub.dart';

class Klub {
  final String id;
  final String nama;
  final String? tglBerdiri;
  final String? kondisi;
  final String? kota;
  final String? peringkat;
  final String? hargaKlub;

  Klub({
    required this.id,
    required this.nama,
    required this.tglBerdiri,
    required this.kondisi,
    required this.kota,
    required this.peringkat,
    required this.hargaKlub,
  });

  factory Klub.fromJson(Map<String, dynamic> json) {
    return Klub(
      id: json['id'],
      nama: json['nama'],
      tglBerdiri: json['tgl_berdiri'],
      kondisi: json['kondisi'],
      kota: json['kota'],
      peringkat: json['peringkat'],
      hargaKlub: json['harga_klub'],
    );
  }
}

void main() {
  runApp(DisplayKlub());
}

String _getKondisi(Klub klub) {
  List<String> jenis = [];
  String kondisi;
  if (klub.kondisi != null && klub.kondisi == '1' || klub.kondisi == '0') {
    jenis.add('Bangkrut');
  } else if (klub.kondisi != null && klub.kondisi == '2') {
    jenis.add('Tidak Baik');
  } else if (klub.kondisi != null && klub.kondisi == '3') {
    jenis.add('Baik');
  }

  return jenis.join(', ');
}

class DisplayKlub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: DisplayKlubPage(),
      ),
    );
  }
}

class DisplayKlubPage extends StatefulWidget {
  @override
  _DisplayKlubPageState createState() => _DisplayKlubPageState();
}
int _currentIndex = 0;

class _DisplayKlubPageState extends State<DisplayKlubPage> {
  //late List<Book> _filteredBooks = []; // Initialize a list for filtered books
  TextEditingController _searchController = TextEditingController();
  late Future<List<Klub>> _klubs;

  Future<List<Klub>> fetchKlubs() async {
    final response =
        await http.get(Uri.parse('http://localhost/genap/klub/api.php'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Klub.fromJson(model)).toList();
    } else {
      throw Exception('Gagal mengambil data klub');
    }
  }

  Future<void> _deleteKlub(String id) async {
    try {
      var url = Uri.parse('http://localhost/genap/klub/delete.php');
      var response = await http.post(
        url,
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        print('Klub berhasil dihapus');
        setState(() {
          _klubs = fetchKlubs();
        });
        // Implement any necessary UI updates or actions upon successful deletion
      } else {
        print('Gagal menghapus klub. Status code: ${response.statusCode}');
        // Implement error handling or display a message to the user
      }
    } catch (error) {
      print('Error: $error');
      // Implement error handling or display a message to the user
    }
  }

  Future<List<Klub>> _searchKlubs(String query) async {
    var allKlubs = await fetchKlubs();
    if (query.isEmpty) {
      return allKlubs;
    } else {
      return allKlubs
          .where(
              (klub) => klub.nama.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _klubs = fetchKlubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Klub Sepak Bola'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Club Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _klubs = fetchKlubs();
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _klubs = _searchKlubs(value);
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Klub>>(
              future: _klubs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var klub = snapshot.data![index];
                      return Card(
                        color: Color.fromARGB(255, 211, 251, 131),
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                klub.nama ?? 'Unknown Title',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Kondisi: ${_getKondisi(klub)}'),
                              Text(
                                  'Tanggal Berdiri: ${klub.tglBerdiri ?? 'Not Available'}'),
                              Text('Kota: ${klub.kota ?? 'Not Available'}'),
                              Text(
                                  'Peringkat: ${klub.peringkat ?? 'Not Available'}'),
                              Text(
                                  'Harga Klub: ${klub.hargaKlub ?? 'Not Available'}'),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditKlub(klub),
                                        ),
                                      );
                                      setState(() {
                                        _klubs = fetchKlubs();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteKlub(klub.id);
                                    },
                                  ),
                                ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddKlubPage(),
            ),
          );
          setState(() {
            _klubs = fetchKlubs();
          });
        },
        child: Icon(Icons.add),
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
