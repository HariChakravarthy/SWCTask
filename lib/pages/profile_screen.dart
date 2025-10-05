import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_app/controllers/recipe_controller.dart';
import 'package:my_first_app/components/recipe_card.dart';
import 'package:my_first_app/controllers/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecipeController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => IconButton(
                    icon: Icon(
                      themeController.isDarkMode.value
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: themeController.toggleTheme,
                  )),
                ],
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recommended Recipes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Obx(
                    () => controller.rxRecipes.isEmpty
                    ? const Center(
                  child: Text(
                    "No recommended recipes available",
                    style: TextStyle(fontSize: 16),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.rxRecipes.take(10).map((r) {
                      final fav = controller.isFavoriteId(r.id);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RecipeCard(
                          recipe: r,
                          isFavorite: fav,
                          onFavoriteToggle: () =>
                              controller.toggleFavorite(r),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
