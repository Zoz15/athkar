import 'package:athkar/presentation/screens/home_screen.dart';
import 'package:athkar/data/datasources/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Initialize LocalStorage
    Get.put(LocalStorage(prefs));
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.black,
      ),
      home:  HomeScreen(),
    );
  }
}