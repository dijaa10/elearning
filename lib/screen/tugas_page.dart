import 'package:flutter/material.dart';

class TugasPage extends StatelessWidget {
  const TugasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        title: const Text('Tugas'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Tugas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),
      ),
    );
  }
}
