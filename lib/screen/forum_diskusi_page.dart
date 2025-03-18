import 'package:flutter/material.dart';

class ForumDiskusiPage extends StatelessWidget {
  const ForumDiskusiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        title: const Text('Forum Diskusi'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Forum Diskusi',
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
