import 'package:flutter/material.dart';

class UjianPage extends StatelessWidget {
  const UjianPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        title: const Text('Ujian'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Ujian',
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
