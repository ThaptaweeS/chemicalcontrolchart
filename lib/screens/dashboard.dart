import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chemicalcontrolchart/utils/constant.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _username, _userEmail, _userRole, _userAvatar, _userPermission;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('loginUsername');
      _userEmail = prefs.getString('loginEmail');
      _userRole = prefs.getString('loginRole');
      _userPermission = prefs.getString('loginPermission');
      _setUserAvatar();
    });
  }

  void _setUserAvatar() {
    switch (_userPermission) {
      case '1':
        _userAvatar = 'assets/images/Prod.png';
        break;
      case '9':
        _userAvatar = 'assets/images/QC.png';
        break;
      case '15':
        _userAvatar = 'assets/images/admin.png';
        break;
      default:
        _userAvatar = 'assets/images/default_avatar.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            icon: const Icon(Icons.qr_code),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${_username ?? 'Username'} (${_userRole ?? 'Role'})'),
              accountEmail: Text(_userEmail ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(_userAvatar ?? 'assets/images/default_avatar.png'),
              ),
            ),
            ListTile(
              title: const Text('Information'),
              leading: const Icon(Icons.info),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              leading: const Icon(Icons.contact_mail),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('loginStatus', false);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            ListTile(
              title: const Text('Version 1.0.0'),
              leading: const Icon(Icons.code),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Dashboard Screen'),
      ),
    );
  }
}
