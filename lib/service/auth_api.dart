import 'dart:convert';
import 'package:flutter_chemicalcontrolchart/utils/constant.dart';
import 'package:http/http.dart' as http;


class AuthAPI {

  // สร้าง header เพื่อกำหนด format ของข้อมูลที่จะส่งไปยัง API
  _setHeaders() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // สร้างฟังก์ชัน Login
  loginAPI(data) async {
    return await http.post(
      Uri.parse('${baseURLAPI}login'),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    print(jsonEncode(data));
  }
  

}