import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_first_app/controllers/recipe_controller.dart';
import 'package:my_first_app/pages/home_screen.dart';
import 'package:my_first_app/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(RecipeController(), permanent: true);
  final themeController = Get.put(ThemeController(), permanent: true);

  runApp(HariApp(themeController: themeController));
}

class HariApp extends StatelessWidget {
  final ThemeController themeController;

  const HariApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      themeMode: themeController.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.orangeAccent,
          secondary: Colors.amber,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SplashScreen(),
    ));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.food_bank_outlined, size: 100, color: Colors.black),
            SizedBox(height: 20),
            Text(
              'Recipe App',
              style: TextStyle(fontSize: 28, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

