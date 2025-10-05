/*import 'package:flutter/material.dart';
import 'package:my_first_app/services/recipe_service.dart';
import 'package:my_first_app/services/recipe_model.dart';
import 'package:my_first_app/components/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final RecipeService _recipeService = RecipeService();

  List<RecipeModel> _recipes = [];
  String? selectedCuisine;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRandom();
  }

  void fetchRandom() async {
    setState(() => isLoading = true);
    final recipes = await _recipeService.fetchRandomRecipes();
    setState(() {
      _recipes = recipes;
      isLoading = false;
    });
  }

  final List<String> topCuisines = ['Indian', 'Italian', 'French', 'American', 'African', 'Chinese' , 'European' ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Saved"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Planner"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Groceries"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Explore",
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: fetchRandom, child: const Text("Refresh"))
                ],
              ),
              const SizedBox(height: 8),
              Positioned(
                top: 60,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 2,
                  shadowColor: Colors.white30,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).cardColor,
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'What are you craving for today ?',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => searchRecipe(_controller.text),
                        ),
                        filled : true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide  :  BorderSide(color: Colors.amber, width: 2),
                        ),
                        focusedBorder  : OutlineInputBorder(
                          borderRadius : BorderRadius.circular(16),
                          borderSide   : BorderSide(color: Colors.amberAccent, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _recipes.isEmpty
                  ? const Text("No recipes found.")
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _recipes.take(10).map((recipe) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RecipeCard(recipe: recipe),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedCuisine,
                hint: const Text(
                  'Select the type Cuisine',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedCuisine = value;
                    if (value != null) searchCuisine(value);
                  });
                },
                iconEnabledColor: Colors.blue[900],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                items: topCuisines.map((cuisine) {
                  return DropdownMenuItem<String>(
                    value: cuisine,
                    child: Text(
                      cuisine,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75, // control tile proportion
                ),
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(recipe: _recipes[index]);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}*/

/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe_model.dart';

class RecipeService {
  final String apiKey = "fdedc48bb9264f3a9a86df8431b3be5f";

  Future<List<RecipeModel>> getRecipeByQuery(String query) async {
    final url =
        'https://api.spoonacular.com/recipes/complexSearch?query=$query&number=10&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch recipes");
    }
  }

  Future<List<RecipeModel>> getRecipesIngredients(String includeIngredients) async {
    final url =
        'https://api.spoonacular.com/recipes/complexSearch?query=$includeIngredients&number=10&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch recipes");
    }
  }

  Future<List<RecipeModel>> getRecipeByIngredients(String ingredients) async {
    final url =
        'https://api.spoonacular.com/recipes/findByIngredients?query=$ingredients&number=10&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch recipes");
    }
  }

  Future<List<RecipeModel>> getRecipeInstructions(String instructions) async {
    final url =
        'https://api.spoonacular.com/recipes/analyzeInstructions?query=$instructions&number=10&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch recipes");
    }
  }

  Future<List<RecipeModel>> fetchRandomRecipes() async {
    final url =
        "https://api.spoonacular.com/recipes/random?number=10&apiKey=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['recipes'];
      return results.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch random recipes");
    }
  }
}*/

/*
Future<List<RecipeModel>> searchWithFilters({
    String? query,
    List<String>? includeIngredients,
    int number = 10,
    String? cuisine,
    String? diet,
  }) async {
    final params = <String, String>{
      'number': number.toString(),
      'apiKey': apiKey,
    };
    if (query != null && query.isNotEmpty) params['query'] = query;
    if (cuisine != null && cuisine.isNotEmpty) params['cuisine'] = cuisine;
    if (diet != null && diet.isNotEmpty) params['diet'] = diet;
    if (includeIngredients != null && includeIngredients.isNotEmpty) {
      final inc = includeIngredients.map((s) => s.trim()).where((s) => s.isNotEmpty).join(',');
      params['includeIngredients'] = inc;
    }

    final uri = Uri.https('api.spoonacular.com', '/recipes/complexSearch', params);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'] ?? [];
      return results.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to search recipes with filters: ${response.statusCode}");
    }
  }
 */