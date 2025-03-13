import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/utama_screen.dart';
import 'login_screen.dart'; // Import halaman login

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? selectedKelas;
  String? selectedJurusan;
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  bool _isLoading = false;

  List<Map<String, dynamic>> kelasList = [];
  List<Map<String, dynamic>> jurusanList = [];

  @override
  void initState() {
    super.initState();
    fetchKelasAndJurusan();
  }

  // Fungsi untuk mengambil data kelas dan jurusan dari API
  Future<void> fetchKelasAndJurusan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mengambil data kelas
      final kelasResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/kelas'),
        headers: {'Accept': 'application/json'},
      );

      // Mengambil data jurusan
      final jurusanResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/jurusan'),
        headers: {'Accept': 'application/json'},
      );

      if (kelasResponse.statusCode == 200 &&
          jurusanResponse.statusCode == 200) {
        final kelasData = json.decode(kelasResponse.body);
        final jurusanData = json.decode(jurusanResponse.body);

        if (kelasData.containsKey('data')) {
          kelasList = List<Map<String, dynamic>>.from(kelasData['data']);
        } else {
          kelasList = List<Map<String, dynamic>>.from(kelasData);
        }

        if (jurusanData.containsKey('data')) {
          jurusanList = List<Map<String, dynamic>>.from(jurusanData['data']);
        } else {
          jurusanList = List<Map<String, dynamic>>.from(jurusanData);
        }

        setState(() {
          kelasList = List<Map<String, dynamic>>.from(kelasData['data']);
          jurusanList = List<Map<String, dynamic>>.from(jurusanData['data']);
        });
      } else {
        showErrorDialog('Gagal mengambil data kelas dan jurusan.');
      }
    } catch (e) {
      print("Error fetching data: $e");
      showErrorDialog('Terjadi kesalahan. Periksa koneksi internet Anda.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk melakukan pendaftaran
  Future<void> register() async {
    // Validasi input
    if (namaController.text.isEmpty ||
        nisnController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedKelas == null ||
        selectedJurusan == null) {
      showWarningDialog('Semua field harus diisi.');
      return;
    }

    // Validasi password match
    if (passwordController.text != confirmPasswordController.text) {
      showWarningDialog('Password tidak cocok.');
      return;
    }

    // URL API register
    const String url = 'http://127.0.0.1:8000/api/siswa/register';

    setState(() {
      _isLoading = true;
    });

    try {
      // Mengirim permintaan HTTP POST ke API register
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'nama': namaController.text,
          'nisn': nisnController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
          'kelas_id': selectedKelas,
          'jurusan_id': selectedJurusan,
        }),
      );

      if (response.statusCode == 201) {
        // Parsing respons JSON dari server
        final data = json.decode(response.body);

        // Jika status register berhasil
        if (data['status'] == 'success') {
          showSuccessDialog();
        } else {
          showErrorDialog(data['message'] ?? 'Pendaftaran gagal.');
        }
      } else if (response.statusCode == 422) {
        // Validasi error dari server
        final data = json.decode(response.body);
        String errorMessage = 'Terjadi kesalahan validasi:';

        if (data['errors'] != null) {
          data['errors'].forEach((key, value) {
            errorMessage += '\n- ${value[0]}';
          });
        }

        showErrorDialog(errorMessage);
      } else {
        showErrorDialog('Gagal mendaftar (${response.statusCode}).');
      }
    } catch (e) {
      print("Error during registration: $e");
      showErrorDialog('Terjadi kesalahan. Periksa koneksi internet Anda.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk menampilkan dialog sukses
  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pendaftaran Berhasil'),
          content: const Text(
              'Akun Anda berhasil dibuat! Silakan login dengan NISN dan password Anda.'),
          actions: [
            TextButton(
              onPressed: () {
                // Menutup dialog
                Navigator.of(context).pop();
                // Berpindah ke halaman Login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog peringatan
  void showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog kesalahan
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pendaftaran Gagal'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengubah visibilitas password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Fungsi untuk mengubah visibilitas konfirmasi password
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9EDF6),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Daftar Akun",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/images/logo.png', width: 200, height: 150),
                const SizedBox(height: 20),

                // Kotak input registrasi
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2446CE),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Input Nama
                      TextField(
                        controller: namaController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person, color: Colors.black54),
                          hintText: 'Nama Lengkap',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Input NISN
                      TextField(
                        controller: nisnController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.numbers, color: Colors.black54),
                          hintText: 'NISN',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Input Email
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.email, color: Colors.black54),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Dropdown Kelas
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedKelas,
                          hint: Text('Pilih Kelas'),
                          isExpanded: true,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.class_, color: Colors.black54),
                            border: InputBorder.none,
                          ),
                          items: kelasList.map((kelas) {
                            return DropdownMenuItem<String>(
                              value: kelas['id'].toString(),
                              child: Text(kelas['nama_kelas']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedKelas = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Dropdown Jurusan
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedJurusan,
                          hint: Text('Pilih Jurusan'),
                          isExpanded: true,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.school, color: Colors.black54),
                            border: InputBorder.none,
                          ),
                          items: jurusanList.map((jurusan) {
                            return DropdownMenuItem<String>(
                              value: jurusan['id'].toString(),
                              child: Text(jurusan['nama_jurusan']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedJurusan = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Input Password
                      TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock, color: Colors.black54),
                          suffixIcon: GestureDetector(
                            onTap: _togglePasswordVisibility,
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
                      const SizedBox(height: 15),

                      // Input Konfirmasi Password
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirmText,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.black54),
                          suffixIcon: GestureDetector(
                            onTap: _toggleConfirmPasswordVisibility,
                            child: Icon(
                              _obscureConfirmText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black54,
                            ),
                          ),
                          hintText: 'Konfirmasi Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tombol Daftar
                      ElevatedButton(
                        onPressed: _isLoading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C9EDB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),

                      const SizedBox(height: 15),

                      // Link ke halaman login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah punya akun?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
