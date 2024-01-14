import 'tampilSuporter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'drawer.dart';

class EditSuporter extends StatefulWidget {
  final Suporter suporter;

  EditSuporter(this.suporter);

  @override
  _EditSuporterState createState() => _EditSuporterState();
}

class _EditSuporterState extends State<EditSuporter> {
  List<int>? imageBytes;
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController noTelpController;
  late String imageUrl;
  late DateTime selectedDate;
  late String fileNameWithExtension;
  late String fileName;
  late String extension;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.suporter.nama);
    alamatController = TextEditingController(text: widget.suporter.alamat);
    noTelpController = TextEditingController(text: widget.suporter.noTelp);
    selectedDate = (widget.suporter.tglDaftar != null
        ? DateTime.parse(widget
            .suporter.tglDaftar!) // Assuming tglDaftar is in a String format
        : DateTime.now());
    imageUrl = widget.suporter.foto ?? ''; // Handle null foto case
  }

  Future<void> _selectImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imageUrl = pickedFile.path;
        imageBytes = bytes;
        fileNameWithExtension = pickedFile.path.split('/').last;
        fileName = fileNameWithExtension.split('.').first;
        extension = fileNameWithExtension.split('.').last;
      });
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

  Future<void> _updateSuporter() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://localhost/genap/suporter/suporterupdate.php'), // Update with your API endpoint
      );

      request.fields['id'] = widget.suporter.id;
      request.fields['nama'] = namaController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['no_telpon'] = noTelpController.text;
      request.fields['tgl_daftar'] = selectedDate != null
          ? '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'
          : '';
      if (imageBytes != null) {
        var imageFile = http.MultipartFile.fromBytes('foto', imageBytes!,
            filename: '$fileName.$extension');
        request.files.add(imageFile);
      }

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
        title: Text('Edit Supporter'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildTextFieldCard(),
            _buildContainer(_buildDatePicker()),
            _buildContainer(_buildImagePicker()),
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
            _buildTextField('Nama', namaController, 'Masukkan Nama'),
            SizedBox(
              height: 10.0,
            ),
            _buildTextField('Alamat', alamatController, 'Masukkan Alamat'),
            SizedBox(
              height: 10.0,
            ),
            _buildTextField(
                'No. Telepon', noTelpController, 'Masukkan No. Telepon'),
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
          'Tanggal Daftar',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(selectedDate == null
              ? 'Pilih Tanggal'
              : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Row(
      children: <Widget>[
        Text(
          'Foto',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(width: 55.0),
        imageUrl.isEmpty
            ? ElevatedButton(
                onPressed: () => _selectImage(context),
                child: Text('Pilih Foto'),
              )
            : Column(
                children: <Widget>[
                  Image.network(
                    imageUrl,
                    width: 100.0,
                    height: 100.0,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectImage(context),
                    child: Text('Ganti Foto'),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _updateSuporter();
      },
      child: Text('Submit'),
    );
  }
}
