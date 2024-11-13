import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nilaiku - app',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NilaiInputPage(),
    );
  }
}

class NilaiInputPage extends StatefulWidget {
  const NilaiInputPage({Key? key}) : super(key: key);

  @override
  _NilaiInputPageState createState() => _NilaiInputPageState();
}

class _NilaiInputPageState extends State<NilaiInputPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nilaiController1 = TextEditingController();
  final TextEditingController _nilaiController2 = TextEditingController();
  final TextEditingController _nilaiController3 = TextEditingController();

  List<Map<String, dynamic>> _students = []; // List to store student names and grades
  String _errorMessage = '';

  void _hitungKategori() {
    setState(() {
      _errorMessage = '';
      String name = _nameController.text;
      int? nilai1 = int.tryParse(_nilaiController1.text);
      int? nilai2 = int.tryParse(_nilaiController2.text);
      int? nilai3 = int.tryParse(_nilaiController3.text);

      // Validate name input (only letters)
      if (name.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
        _errorMessage = 'Masukkan nama siswa yang valid';
        return;
      }

      // Validate score inputs
      if (nilai1 == null || nilai2 == null || nilai3 == null) {
        _errorMessage = 'Masukkan semua nilai yang valid';
        return;
      }

      if (nilai1 < 0 || nilai1 > 100 ||
          nilai2 < 0 || nilai2 > 100 ||
          nilai3 < 0 || nilai3 > 100) {
        _errorMessage = 'Masukkan nilai yang valid (0-100)';
        return;
      }

      double rataRata = (nilai1 + nilai2 + nilai3) / 3;

      String kategori;
      if (rataRata >= 85) {
        kategori = 'A';
      } else if (rataRata >= 70) {
        kategori = 'B';
      } else if (rataRata >= 55) {
        kategori = 'C';
      } else {
        kategori = 'D';
      }

      // Check if list is full before adding new entry
      if (_students.length >= 40) {
        _errorMessage = 'Daftar siswa sudah penuh (40 entry)';
        return;
      }

      // Add student name, category, and average to the list
      _students.add({
        'name': name,
        'kategori': kategori,
        'rataRata': rataRata,
      });

      // Clear input fields
      _nameController.clear();
      _nilaiController1.clear();
      _nilaiController2.clear();
      _nilaiController3.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NilaiKu'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Section
            const Text(
              'Masukkan Nama dan Nilai Siswa:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Name Input Field Section
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Siswa',
                errorText: _errorMessage.isNotEmpty && _nameController.text.isEmpty ? _errorMessage : null,
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Allow only letters and spaces
              ],
            ),
            const SizedBox(height: 10),

            // Input Field Section for Score 1
            TextField(
              controller: _nilaiController1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nilai MiPa (0-100)',
                errorText: _errorMessage.isNotEmpty && _nilaiController1.text.isEmpty ? _errorMessage : null,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Input Field Section for Score 2
            TextField(
              controller: _nilaiController2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nilai IPS (0-100)',
                errorText: _errorMessage.isNotEmpty && _nilaiController2.text.isEmpty ? _errorMessage : null,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Input Field Section for Score 3
            TextField(
              controller: _nilaiController3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nilai Bahasa (0-100)',
                errorText: _errorMessage.isNotEmpty && _nilaiController3.text.isEmpty ? _errorMessage : null,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Enhanced Button Section
            ElevatedButton(
              onPressed: _hitungKategori,
              child: const Icon(Icons.calculate),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal, // Button color
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                elevation: 5, // Shadow effect
              ),
            ),
            const SizedBox(height: 30),

            // Result Section
            Expanded(
              child: ListView.builder(
                itemCount: min(_students.length, 40), // Limit to 40 entries
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title:
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_students[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text('Rata-rata Nilai : ${_students[index]['rataRata'].toStringAsFixed(2)}'),
                        Text('Kategori Nilai : ${_students[index]['kategori']}'),
                      ]),
                      leading:
                          CircleAvatar(child: Text('${index + 1}')),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}