import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_app/controllers/recipe_controller.dart';
import 'package:my_first_app/components/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecipeController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "Your Favorites",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.favorites.isEmpty) {
                  return const Center(
                    child: Text(
                      "No favorites yet",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.favorites.length,
                  itemBuilder: (context, i) {
                    final recipe = controller.favorites[i];
                    return RecipeCard(
                      recipe: recipe,
                      isFavorite: true,
                      onFavoriteToggle: () => controller.toggleFavorite(recipe),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
