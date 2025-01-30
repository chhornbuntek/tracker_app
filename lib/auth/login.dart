import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:tracker_app/auth/register.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:tracker_app/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: const Color(0xff1ace99),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    const Text(
                      'Sign in to your',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Sign in to your Account',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText ? Iconsax.eye_slash : Iconsax.eye,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      loginUser(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1ace99),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () => Get.to(() => SignUpScreen()),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xff1ace99),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
    );
  }

  Future<void> loginUser(String email, String password) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D6EFD)),
            strokeWidth: 5.0,
          ),
        ),
      );

      final response = await http.post(
        Uri.parse('http://192.168.0.65:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print("Response: ${response.body}");

      final data = jsonDecode(response.body);

      Navigator.pop(context);

      if (data['accessToken'] != null && data['refreshToken'] != null) {
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        await _storage.write(key: 'accessToken', value: accessToken);
        await _storage.write(key: 'refreshToken', value: refreshToken);

        if (JwtDecoder.isExpired(accessToken)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session has expired. Please login again.'),
              backgroundColor: Colors.red,
            ),
          );
          await _storage.deleteAll();
          Get.offAll(() => const LoginScreen());
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Success!',
            desc: 'Login Successfully!',
            btnOkText: 'Okay',
            btnOkColor: const Color(0xFF0D6EFD),
            btnOkOnPress: () {
              Get.offAll(() => const HomeScreen());
            },
          ).show();
        }
      } else {
        final message = data['message'] ?? "Login failed. Please try again.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('http://192.168.0.65:3000/api/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': refreshToken}),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        await _storage.write(key: 'accessToken', value: data['accessToken']);
      } else {
        await _storage.deleteAll();
        Get.offAll(() => const LoginScreen());
      }
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  void checkLoginStatus() async {
    final accessToken = await _storage.read(key: 'accessToken');

    if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      Get.off(() => const HomeScreen());
    } else {
      await _storage.deleteAll();
      Get.off(() => const LoginScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }
}
