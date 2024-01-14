import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'displayKlub.dart';
import 'drawer.dart';

class EditKlub extends StatefulWidget {
  final Klub klub;

  EditKlub(this.klub);

  @override
  _EditKlubState createState() => _EditKlubState();
}

class _EditKlubState extends State<EditKlub> {
  late TextEditingController namaController;
  late TextEditingController kotaController;
  late TextEditingController hargaController;
  late String nama;
  late String kota;
  late String harga;
  late DateTime selectedDate;
  late String selectedPeringkat;
  late String selectedKondisi;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.klub.nama);
    kotaController = TextEditingController(text: widget.klub.kota);
    hargaController = TextEditingController(text: widget.klub.hargaKlub);
    selectedDate = (widget.klub.tglBerdiri != null
        ? DateTime.parse(widget.klub.tglBerdiri!)
        : null)!;
    selectedPeringkat = widget.klub.peringkat!;
    if (widget.klub.kondisi == '1' || widget.klub.kondisi == '0') {
      selectedKondisi = 'Bangkrut';
    } else if (widget.klub.kondisi == '2') {
      selectedKondisi = 'Tidak Baik';
    } else {
      selectedKondisi = 'Baik';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _updateKlub() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://localhost/genap/klub/update.php'), // Update with your API endpoint
      );
      request.fields['id'] = widget.klub.id;
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
        print('Data updated successfully');
        Navigator.pop(context);
      } else {
        print('Error updating data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Klub'),
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
        _updateKlub();
      },
      child: Text('Submit'),
    );
  }
}
