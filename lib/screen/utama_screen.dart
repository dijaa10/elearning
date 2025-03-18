import 'package:flutter/material.dart';
// Import halaman-halaman list
import 'dashboard_page.dart';
import 'mata_pelajaran_page.dart';
import 'tugas_page.dart';
import 'ujian_page.dart';
import 'forum_diskusi_page.dart';
import 'profil_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1976D2),
        elevation: 0, // Tanpa bayangan
        title: const Text('E-Learning SMKN 1 Sumberasih'),
        centerTitle: true,
      ),
      drawer: const SimpleDrawer(),
      body: Center(
        child: Column(
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
              'Person',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            accountEmail: const Text('person@gmail.com'),
            // Foto profil pengguna
            currentAccountPicture: CircleAvatar(),
          ),

          _buildMenuItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () => _navigateTo(context, const DashboardPage()),
          ),

          _buildMenuItem(
            context,
            icon: Icons.book,
            title: 'Mata Pelajaran',
            onTap: () => _navigateTo(context, const MataPelajaranPage()),
          ),

          _buildMenuItem(
            context,
            icon: Icons.assignment,
            title: 'Tugas',
            onTap: () => _navigateTo(context, const TugasPage()),
          ),

          _buildMenuItem(
            context,
            icon: Icons.quiz,
            title: 'Ujian',
            onTap: () => _navigateTo(context, const UjianPage()),
          ),

          _buildMenuItem(
            context,
            icon: Icons.forum,
            title: 'Forum Diskusi',
            onTap: () => _navigateTo(context, const ForumDiskusiPage()),
          ),

          _buildMenuItem(
            context,
            icon: Icons.person,
            title: 'Profil',
            onTap: () => _navigateTo(context, const ProfilPage()),
          ),

          const Divider(),

          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Keluar',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              // Implementasi logout
              Navigator.pop(context);
              // Di sini bisa tambahkan logic untuk logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout berhasil')),
              );
            },
          ),
          // Jarak di bagian bawah
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Fungsi untuk navigasi ke halaman yang dituju
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Tutup drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Fungsi helper untuk membuat item menu drawer
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing, // Widget tambahan di bagian kanan (opsional)
    Color iconColor = Colors.blueGrey,
    Color textColor = Colors.black87,
    VoidCallback? onTap,
  }) {
    return ListTile(
      // kiri
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
      // Widget tambahan di bagian kanan (jika ada)
      trailing: trailing,
      // Fungsi yang dijalankan saat item menu ditekan
      onTap: onTap,
    );
  }
}
