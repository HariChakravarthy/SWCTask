import 'package:flutter/material.dart';
import 'package:my_first_app/services/recipe_model.dart';
import 'package:my_first_app/services/recipe_service.dart';
import 'package:get/get.dart';
import 'package:my_first_app/controllers/theme_controller.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<RecipeModel> _recipeFuture;
  final RecipeService _recipeService = RecipeService();
  final themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _recipeFuture = _recipeService.getRecipeDetails(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RecipeModel>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Recipe not found'));
          }

          final recipe = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                  background: Image.network(
                    recipe.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (recipe.readyInMinutes != null)
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.redAccent),
                            const SizedBox(width: 6),
                            Text(
                              '${recipe.readyInMinutes!.toInt()} mins',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      if (recipe.summary != null)
                        Text(
                          _removeHtmlTags(recipe.summary!),
                          style: TextStyle(
                              fontSize: 14,
                              color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                              height: 1.5),
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: recipe.ingredients?.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        fontSize: 14,
                                      color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList() ?? [const SizedBox.shrink()], // Handle the null case explicitly
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Instructions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (recipe.instructions != null)
                        Text(
                          _removeHtmlTags(recipe.instructions!),
                          style: TextStyle(
                              fontSize: 14,
                              color: themeController.isDarkMode.value ? Colors.white : Colors.white30,
                              height: 1.5
                          ),
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  String _removeHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(regex, '');
  }
}

/*const Text(
                        'Ingredients',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (recipe.ingredients != null)
                        ...recipe.ingredients!.map(
                              (item) => Row(
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  color: Colors.green, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),*/
