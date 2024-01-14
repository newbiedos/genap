import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pab_uas/auth/navbar.dart';

class ViewKlub extends StatefulWidget {
  @override
  _ViewKlubState createState() => _ViewKlubState();
}
int _currentIndex = 1;
class _ViewKlubState extends State<ViewKlub> {
  late Future<List<Klub>> _klubs;

  Future<List<Klub>> fetchKlubs() async {
    final response = await http.get(Uri.parse('http://localhost/genap/klub/api.php'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Klub.fromJson(model)).toList();
    } else {
      throw Exception('Gagal mengambil data klub');
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
        title: Text('View Klub'),
      ),
      body: FutureBuilder<List<Klub>>(
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
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
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

String _getKondisi(Klub klub) {
  List<String> jenis = [];
  if (klub.kondisi != null && (klub.kondisi == '1' || klub.kondisi == '0')) {
    jenis.add('Bangkrut');
  } else if (klub.kondisi != null && klub.kondisi == '2') {
    jenis.add('Tidak Baik');
  } else if (klub.kondisi != null && klub.kondisi == '3') {
    jenis.add('Baik');
  }

  return jenis.join(', ');
}

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

