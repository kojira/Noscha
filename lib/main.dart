import 'package:flutter/material.dart';
import 'package:my_app/i18n/strings.g.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: t.Noscha,
        home: const BottomNavigation(),
        theme: ThemeData(
            primaryColor:
                const Color.fromARGB(255, 143, 128, 187), // primaryColorを赤に設定
            appBarTheme:
                const AppBarTheme(color: Color.fromARGB(255, 143, 128, 187))));
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  final _pages = [
    const HomeView(),
    Center(child: Text(t.Search)),
    Center(child: Text(t.Notifications)),
    Center(child: Text(t.Profile)),
  ];
  List<String> appBarTitles = [t.Home, t.Search, t.Notifications, t.Profile];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitles[_currentIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                image: AssetImage('assets/images/header_background.png'),
                fit: BoxFit.cover, // 画像が領域全体にフィットするように指定
              )),
              child: Text(""),
            ),
            ListTile(
              title: Text(t.Bookmarks),
              onTap: () {
                Navigator.pop(context); // ドロワーを閉じます
              },
            ),
            ListTile(
              title: Text(t.Settings),
              onTap: () {
                Navigator.pop(context); // ドロワーを閉じます
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: const TextStyle(fontSize: 0),
        unselectedLabelStyle: const TextStyle(fontSize: 0),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: t.Home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: t.Search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: t.Notifications,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: t.Profile,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
