import 'package:flutter/material.dart';
import 'package:my_first_app/pages/recipe_screen.dart';
import 'package:my_first_app/pages/fav_recipe_screen.dart';
import 'package:my_first_app/pages/planner_screen.dart';
import 'package:my_first_app/pages/profile_screen.dart';
import 'package:my_first_app/components/floating_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final screens = const [
    RecipeScreen(),
    FavoritesScreen(),
    PlannerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
