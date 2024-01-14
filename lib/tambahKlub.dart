import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';

void main() {
  runApp(AddKlub());
}

class AddKlub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: AddKlubPage(),
      ),
    );
  }
}

class AddKlubPage extends StatefulWidget {
  @override
  _AddKlubPageState createState() => _AddKlubPageState();
}

class _AddKlubPageState extends State<AddKlubPage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  String nama = '';
  String kota = '';
  String harga = '';
  DateTime? selectedDate;
  String? selectedPeringkat;
  String? selectedKondisi;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _showMessageBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Klub Berhasil Ditambahkan"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/genap/klub/api.php'),
      );
      request.fields['nama'] = namaController.text;
      request.fields['kota'] = kotaController.text;
      request.fields['harga_klub'] = hargaController.text;
      request.fields['tgl_berdiri'] = selectedDate != null
          ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
          : '';
      request.fields['peringkat'] = selectedPeringkat ?? '';
      request.fields['kondisi'] = selectedKondisi ?? '';

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Data inserted successfully');
      } else {
        print('Error inserting data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Klub Baru'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildTextFieldCard(),
            _buildContainer(_buildDatePicker()),
            _buildContainer(_buildComboBox()),
            _buildContainer(_buildRadioButtonGroup()),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldCard() {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Nama Klub', namaController, 'Masukkan Nama Klub'),
            SizedBox(
              height: 10.0,
            ),
            _buildTextField('Kota Klub', kotaController, 'Masukkan Kota Klub'),
            SizedBox(
              height: 10.0,
            ),
            _buildTextField(
                'Harga Klub', hargaController, 'Masukkan Harga Klub'),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: <Widget>[
        Text(
          'Tanggal Berdiri',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(selectedDate == null
              ? 'Masukkan Tanggal'
              : '${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}'),
        ),
      ],
    );
  }

  Widget _buildComboBox() {
    return Row(
      children: <Widget>[
        Text(
          'Peringkat',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(width: 86.0),
        DropdownButton<String>(
          value: selectedPeringkat,
          onChanged: (String? newValue) {
            setState(() {
              selectedPeringkat = newValue!;
            });
          },
          items: <String>[
            '1',
            '2',
            '3',
            '4',
            '5',
            '6',
            '7',
            '8',
            '9',
            '10',
            '11',
            '12',
            '13',
            '14',
            '15',
            '16',
            '17',
            '18'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRadioButtonGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Kondisi',
          style: TextStyle(fontSize: 16.0),
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 'Baik',
              groupValue: selectedKondisi,
              onChanged: (String? value) {
                setState(() {
                  selectedKondisi = value!;
                });
              },
            ),
            Text('Baik'),
            SizedBox(width: 20.0),
            Radio(
              value: 'Tidak Baik',
              groupValue: selectedKondisi,
              onChanged: (String? value) {
                setState(() {
                  selectedKondisi = value!;
                });
              },
            ),
            Text('Tidak Baik'),
            SizedBox(width: 20.0),
            Radio(
              value: 'Bangkrut',
              groupValue: selectedKondisi,
              onChanged: (String? value) {
                setState(() {
                  selectedKondisi = value!;
                });
              },
            ),
            Text('Bangkrut'),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _showMessageBox();
      },
      child: Text('Submit'),
    );
  }
}
