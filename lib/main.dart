import 'package:athkar/presentation/screens/home_screen.dart';
import 'package:athkar/data/datasources/local_storage.dart';
import 'package:athkar/var.dart';
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // Initialize LocalStorage
    Get.put(LocalStorage(prefs));
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.light(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
          surface: Colors.white,
          background: Colors.white,
          onBackground: Colors.black87,
          onSurface: Colors.black87,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
          surface: Colors.grey[900]!,
          background: Colors.black,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}