import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar di bagian atas layar
      appBar: AppBar(
        // Judul
        backgroundColor: Color(0xFF1976D2),
        elevation: 0, // Tanpa bayangan
        title: const Text('E-Learning SMKN 1 Sumberasih'),
        // Membuat judul berada di tengah AppBar
        centerTitle: true,
      ),
      // Menambahkan drawer (menu samping) ke halaman
      drawer: const SimpleDrawer(),
      // Konten utama halaman
      body: Center(
        // Column untuk menata widget secara vertikal
        child: Column(
          // Menempatkan widget di tengah secara vertikal
          mainAxisAlignment: MainAxisAlignment.center,
          // Daftar widget yang ditampilkan
          children: const [
            // Ikon sekolah
            Icon(
              Icons.school,
              size: 64, // Ukuran ikon
              color: Color(0xFF1976D2), // Warna biru
            ),
            // Jarak vertikal 16 pixel
            SizedBox(height: 16),
            // Teks sambutan
            Text(
              'Selamat Datang di E-Learning',
              style: TextStyle(
                fontSize: 24, // Ukuran font
                fontWeight: FontWeight.bold, // Tebal
                color: Color(0xFF1976D2), // Warna biru
              ),
            ),
            // Teks nama sekolah
            Text(
              'SMKN 1 Sumberasih',
              style: TextStyle(
                fontSize: 18, // Ukuran font
                color: Colors.black54, // Warna abu-abu
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk membuat drawer (menu samping)
class SimpleDrawer extends StatelessWidget {
  const SimpleDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Widget Drawer untuk menu samping
    return Drawer(
      // ListView memungkinkan konten di-scroll jika melebihi tinggi layar
      child: ListView(
        // Menghilangkan padding default
        padding: EdgeInsets.zero,
        // Daftar item dalam drawer
        children: [
          // Header drawer dengan informasi pengguna
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2), // Warna biru
            ),

            accountName: const Text(
              'Dija',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            accountEmail: const Text('dija@gmail.com'),
            // Foto profil pengguna
            currentAccountPicture: CircleAvatar(),
          ),
          // Item menu Dashboard
          _buildMenuItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
          ),
          // Item menu Mata Pelajaran dengan badge notifikasi
          _buildMenuItem(
            context,
            icon: Icons.book,
            title: 'Mata Pelajaran',
          ),
          // Item menu Tugas
          _buildMenuItem(
            context,
            icon: Icons.assignment,
            title: 'Tugas',
          ),
          // Item menu Ujian
          _buildMenuItem(
            context,
            icon: Icons.quiz,
            title: 'Ujian',
          ),
          // Item menu Forum Diskusi
          _buildMenuItem(
            context,
            icon: Icons.forum,
            title: 'Forum Diskusi',
          ),
          // Item menu Profil
          _buildMenuItem(
            context,
            icon: Icons.person,
            title: 'Profil',
          ),
          // Garis pemisah
          const Divider(),
          // Item menu Keluar dengan warna merah
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Keluar',
            textColor: Colors.red,
            iconColor: Colors.red,
          ),
          // Jarak di bagian bawah
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Fungsi helper untuk membuat item menu drawer
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon, // Ikon yang ditampilkan
    required String title, // Judul menu
    Widget? trailing, // Widget tambahan di bagian kanan (opsional)
    Color iconColor = Colors.blueGrey,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      // Ikon di bagian kiri
      leading: Icon(
        icon,
        color: iconColor,
      ),
      // Teks judul menu
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500, // Sedikit tebal
        ),
      ),

      // Fungsi yang dijalankan saat item menu ditekan
      onTap: () {
        // Menutup drawer
        Navigator.pop(context);
        // Komentar untuk implementasi navigasi di masa depan
        // Implementasi navigasi ke halaman yang sesuai
      },
    );
  }
}
