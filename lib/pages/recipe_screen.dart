import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_app/controllers/recipe_controller.dart';
import 'package:my_first_app/controllers/theme_controller.dart';
import 'package:my_first_app/components/recipe_card.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RecipeController controller = Get.put(RecipeController());
  final themeController = Get.find<ThemeController>();

  String selectedCuisine = 'Indian';
  bool isLoading = false;

  final List<String> mainIngredients = [
    'Chicken',
    'Egg',
    'Rice',
    'Tomato',
    'Cheese',
    'Potato',
    'Fish',
    'Paneer',
    'Onion',
    'Garlic',
  ];
  final Set<String> selectedIngredients = {};

  final List<String> topCuisines = [
    'Indian',
    'Italian',
    'French',
    'American',
    'African',
    'Chinese',
    'European'
  ];

  @override
  void initState() {
    super.initState();
    controller.fetchRecipes(query: '', number: 10);
  }

  Future<void> _searchRecipe(String query) async {
    if (query.trim().isEmpty) return;
    controller.fetchRecipes(query: query, number: 10);
  }

  Future<void> _searchByIngredients() async {
    if (selectedIngredients.isEmpty) return;
    isLoading = true;
    try {
      await controller.fetchByIngredients(selectedIngredients.toList());
    } catch (e) {
      debugPrint('Error searching by ingredients: $e');
    } finally {
      isLoading = false;
    }
  }

  void _toggleIngredient(String ingredient) {
    setState(() {
      if (selectedIngredients.contains(ingredient)) {
        selectedIngredients.remove(ingredient);
      } else {
        selectedIngredients.add(ingredient);
      }
    });
    _searchByIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Material(
                elevation: 2,
                shadowColor: themeController.isDarkMode.value ? Colors.white : Colors.white30,
                borderRadius: BorderRadius.circular(20),
                child: TextField(
                  controller: _controller,
                  onSubmitted: _searchRecipe,
                  decoration: InputDecoration(
                    labelText: 'What are you craving for today?',
                    labelStyle: TextStyle(
                        color: themeController.isDarkMode.value ? Colors.white.withOpacity(0.9) : Colors.grey[700],
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _searchRecipe(_controller.text),
                    ),
                    filled: true,
                    fillColor: themeController.isDarkMode.value ? Colors.white.withOpacity(0.1) : Colors.white60,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                      const BorderSide(color: Colors.orangeAccent, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                      BorderSide(
                          color: themeController.isDarkMode.value ? Colors.orangeAccent : Colors.orange, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: mainIngredients.map((ingredient) {
                    final isSelected = selectedIngredients.contains(ingredient);
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: FilterChip(
                        label: Text(ingredient),
                        selected: isSelected,
                        onSelected: (_) => _toggleIngredient(ingredient),
                        selectedColor: themeController.isDarkMode.value ? Colors.orangeAccent : Colors.orange,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: DropdownButton<String>(
                  value: selectedCuisine,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => selectedCuisine = value);
                    controller.selectedCuisine.value = value;
                    controller.fetchRecipes(query: '', number: 10);
                  },
                  dropdownColor: themeController.isDarkMode.value ? Colors.black : Colors.white,
                  style: TextStyle(
                    color: themeController.isDarkMode.value ? Colors.orangeAccent : Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  iconEnabledColor: themeController.isDarkMode.value ? Colors.orangeAccent : Colors.orange,
                  items: topCuisines.map((cuisine) {
                    return DropdownMenuItem<String>(
                      value: cuisine,
                      child: Text(
                        cuisine,
                        style: TextStyle(
                          color: themeController.isDarkMode.value ? Colors.orangeAccent : Colors.orange,
                        ),
                      ),
                    );
                  }).toList(),
                )
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.rxRecipes.isEmpty) {
                    return const Center(child: Text("No recipes found."));
                  }
                  return GridView.builder(
                    controller: _scrollController,
                    itemCount: controller.rxRecipes.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final recipe = controller.rxRecipes[index];
                      final fav = controller.isFavoriteId(recipe.id);
                      return RecipeCard(
                        recipe: recipe,
                        isFavorite: fav,
                        onFavoriteToggle: () =>
                            controller.toggleFavorite(recipe),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*TextButton(
                    onPressed: () =>
                        controller.fetchRecipes(query: '', number: 10),
                    child: const Text(
                        "Refresh",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),*/
