import 'package:demo/routes/AdminPage.dart';
import 'package:demo/routes/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

final ThemeData themeData = new ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final HomePage homePage = HomePage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save a friend',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: Text('Salva a un amigo')),
              body: homePage,
              drawer: Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Inicio'),
                      onTap: () => goToHome(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.pets),
                      title: Text('Administrador'),
                      onTap: () => goToAdmin(context),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  void goToAdmin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminPage()),
    ).then((value) => homePage.petList.petListState.refresh());
  }

  void goToHome(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }
}
