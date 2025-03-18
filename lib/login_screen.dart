import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // untuk melakukan permintaan HTTP ke server
import 'dart:convert'; // untuk mengubah data JSON menjadi objek Dart
import 'package:shared_preferences/shared_preferences.dart'; //shared_preferences untuk menyimpan data secara lokal
import 'screen/utama_screen.dart'; // mengimpor halaman utama aplikasi setelah login

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nisnController =
      TextEditingController(); // untuk menyimpan input nisn
  final TextEditingController passwordController =
      TextEditingController(); // untuk menyimpan input password
  bool _obscureText = true; // untuk menyembunyikan atau menampilkan password
  bool _isLoading = false; // untuk menampilkan indikator loading saat login

// Fungsi untuk melakukan login
  Future<void> login() async {
    // Validasi NISN dan password tidak kosong
    if (nisnController.text.isEmpty || passwordController.text.isEmpty) {
      showWarningDialog('Masukkan NISN dan password untuk login.');
      return; // Hentikan proses login jika input kosong
    }

    // URL API login (route laravel)
    const String url = 'http://127.0.0.1:8000/api/siswa/login';

    // Set state untuk menampilkan indikator loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Mengirim permintaan HTTP POST ke API login
      final response = await http.post(
        Uri.parse(url), // Mengonversi string URL menjadi Uri
        headers: {
          'Content-Type':
              'application/json', // Format data yang dikirim adalah JSON
          'Accept': 'application/json', // Meminta respons dalam format JSON
        },
        body: json.encode({
          'nisn': nisnController.text, // Mengirimkan NISN dari inputan
          'password':
              passwordController.text, // Mengirimkan password dari inputan
        }),
      );

      // Mengecek status kode dari respons API
      if (response.statusCode == 200) {
        // Parsing respons JSON dari server
        final data = json.decode(response.body);

        // Jika status login berhasil
        if (data['status'] == 'success') {
          await saveUserData(data); // Simpan data pengguna ke penyimpanan lokal
          showSuccessDialog(); // Menampilkan dialog sukses login
        } else {
          // Jika login gagal, menampilkan pesan error dari server
          showErrorDialog(data['message'] ??
              'Login gagal. Periksa kembali NISN dan password Anda.');
        }
      } else if (response.statusCode == 401) {
        // Jika server mengembalikan kode 401 (Unauthorized), menampilkan pesan kesalahan login
        showErrorDialog('NISN atau password salah. Silakan coba lagi.');
      } else {
        // Jika ada kesalahan lain dari server, tampilkan status kode error
        showErrorDialog('Gagal menghubungi server (${response.statusCode}).');
      }
    } catch (e) {
      // Menangani error saat menghubungi server, misalnya koneksi internet bermasalah
      print("Error during login: $e");
      showErrorDialog('Terjadi kesalahan. Periksa koneksi internet Anda.');
    } finally {
      // Setelah proses login selesai (berhasil atau gagal), sembunyikan indikator loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk menampilkan dialog sukses saat login berhasil
  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Berhasil'),
          content: const Text('Anda berhasil masuk!'),
          actions: [
            TextButton(
              onPressed: () {
                // Menutup dialog
                Navigator.of(context).pop();
                // Berpindah ke halaman HomePage setelah login sukses
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog peringatan jika input tidak lengkap
  void showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: Text(
              message), // Menampilkan pesan peringatan yang diterima sebagai parameter
          actions: [
            TextButton(
              onPressed: () {
                // Menutup dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog kesalahan jika login gagal
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Gagal'),
          content: Text(message), // Menampilkan pesan error dari parameter
          actions: [
            TextButton(
              onPressed: () {
                // Menutup dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menyimpan data user setelah login berhasil menggunakan SharedPreferences
  Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs =
        await SharedPreferences.getInstance(); // Mengakses SharedPreferences

    // Menyimpan token
    if (data['token'] != null) {
      await prefs.setString('token', data['token']);
    }

    // Menyimpan informasi user
    if (data['siswa'] != null) {
      await prefs.setString('siswa_id', data['siswa']['id'].toString());
      await prefs.setString('nisn', data['siswa']['nisn']);
      await prefs.setString('nama', data['siswa']['nama']);
      await prefs.setString('email', data['siswa']['email']);
      await prefs.setString('kelas_id', data['siswa']['kelas_id'].toString());
      await prefs.setString(
          'jurusan_id', data['siswa']['jurusan_id'].toString());
      print('Foto Profil: ${data['siswa']['foto_profil']}');
    }
    await prefs.setBool('isLoggedIn', true); // Menandai bahwa user sudah login
  }

  // Fungsi untuk menampilkan atau menyembunyikan password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Mengubah status visibility password
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9EDF6), // Warna latar belakang halaman
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
                20.0), // Padding untuk tata letak yang lebih rapi
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Pusatkan elemen secara vertikal
              children: [
                const Text(
                  "Login Siswa",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Menggunakan font Poppins
                  ),
                ),
                const SizedBox(height: 20), // Jarak antar elemen
                Image.asset('assets/images/logo.png',
                    width: 250, height: 200), // Logo aplikasi
                const SizedBox(height: 20),

                // Kotak input login
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF2446CE), // Warna latar belakang kotak
                    borderRadius: BorderRadius.circular(25), // Sudut membulat
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, // Bayangan
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Input NISN
                      TextField(
                        controller: nisnController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Warna latar belakang input
                          prefixIcon: Icon(Icons.person,
                              color: Colors.black54), // Ikon user
                          hintText: 'Masukkan NISN',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none, // Hilangkan border
                          ),
                        ),
                      ),
                      const SizedBox(height: 18), // Jarak antar input field

                      // Input Password
                      TextField(
                        controller: passwordController,
                        obscureText:
                            _obscureText, // Menyembunyikan karakter password
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock,
                              color: Colors.black54), // Ikon password
                          suffixIcon: GestureDetector(
                            onTap:
                                _togglePasswordVisibility, // Mengubah visibilitas password
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black54,
                            ),
                          ),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Tombol Lupa Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Tambahkan fungsi lupa password di sini
                          },
                          child: const Text(
                            'Lupa password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tombol Login
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : login, // Nonaktifkan tombol jika sedang loading
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF5C9EDB), // Warna tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Membulatkan sudut tombol
                          ),
                          minimumSize: const Size(
                              double.infinity, 50), // Ukuran tombol penuh
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ) // Menampilkan loading jika sedang proses login
                            : const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
