import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chemicalcontrolchart/service/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formLoginKey = GlobalKey<FormState>();
  String? _username, _password;
  bool _obscureText = true; // Variable to control password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth < 600 ? 16.0 : 480.0,
                  ),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/tpklogo.png',
                            height: 200,
                          ),
                          Form(
                            key: _formLoginKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: '',
                                  decoration: const InputDecoration(
                                    hintText: 'User',
                                    prefixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'กรุณากรอกชื่อผู้ใช้งาน';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _username = value;
                                  },
                                  autofillHints: const [AutofillHints.username],
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  initialValue: '',
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'กรุณากรอกรหัสผ่าน';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _password = value;
                                  },
                                  autofillHints: const [AutofillHints.password],
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formLoginKey.currentState!.validate()) {
                                      _formLoginKey.currentState!.save();
                                      print('Attempting to login with:');
                                      print('Username: $_username');
                                      print('Password: $_password');

                                      try {
                                        var response = await AuthAPI().loginAPI({
                                          'username': _username,
                                          'password': _password,
                                        });

                                        print('API response: ${response.body}');
                                        var body = jsonDecode(response.body);

                                        // Assume login is successful if the response contains "permission"
                                        if (body.containsKey('permission')) {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool('loginStatus', true);
                                          prefs.setString('loginName', body['name']);
                                          prefs.setString('loginUsername', body['username']);
                                          prefs.setString('loginRole', body['role']);
                                          prefs.setString('loginPermission', body['permission']); // Corrected key

                                          print('Login successful, navigating to dashboard...');
                                          Navigator.pushReplacementNamed(context, '/dashboard');
                                        } else {
                                          print('Login failed: ${body['message']}');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              behavior: SnackBarBehavior.floating,
                                              content: Text('Username หรือ Password ไม่ถูกต้อง'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        print('Error during login: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text('LOG IN'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
