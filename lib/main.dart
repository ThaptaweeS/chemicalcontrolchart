import 'package:flutter/material.dart';
import 'package:flutter_chemicalcontrolchart/screens/dashboard.dart';
import 'package:flutter_chemicalcontrolchart/screens/home.dart';
import 'package:flutter_chemicalcontrolchart/screens/login.dart';



dynamic initialRoute;

void main() async {
 
    initialRoute = '/login';
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       primarySwatch: Colors.blue,
       useMaterial3: false,
      ),
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => const Home(),
        // '/about': (context) => const About(),
     
        '/login':(context) => const Login(),
        '/dashboard':(context) => const Dashboard(),
        // '/machine_detail':(context) => const MachineDetail(),
        // '/chart':(context) => const ChartReport(),
      },
    );
  }
}

