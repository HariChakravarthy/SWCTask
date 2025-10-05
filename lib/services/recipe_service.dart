import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe_model.dart';

class RecipeService {
  final String apiKey = "50c108ba357b493282d49d5a7b3cc838";

  Future<List<RecipeModel>> getRecipeByQuery(
      String query, {
        int number = 10,
        int offset = 0,
        String? cuisine,
        String? diet,
      }) async {
    final params = <String, String>{
      'query': query,
      'number': number.toString(),
      'offset': offset.toString(),
      'addRecipeInformation': 'true',
      'apiKey': apiKey,
    };
    if (cuisine != null && cuisine.isNotEmpty) {
      params['cuisine'] = cuisine;
    }
    if (diet != null && diet.isNotEmpty) {
      params['diet'] = diet;
    }
    final uri = Uri.https('api.spoonacular.com', '/recipes/complexSearch', params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'] ?? [];
      return results.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch recipes: ${response.statusCode}");
    }
  }

  Future<List<RecipeModel>> getRecipesByIngredients(
      List<String> ingredients, {
        int number = 10,
      }) async {
    final ingredientParam = ingredients.map((s) => s.trim()).where((s) => s.isNotEmpty).join(',');
    final params = <String, String>{
      'ingredients': ingredientParam,
      'number': number.toString(),
      'apiKey': apiKey,
    };

    final uri = Uri.https('api.spoonacular.com', '/recipes/findByIngredients', params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) {
        return RecipeModel.fromJson(json);
      }).toList();
    } else {
      throw Exception("Failed to fetch recipes by ingredients: ${response.statusCode}");
    }
  }

  Future<RecipeModel> getRecipeDetails(int recipeId) async {
    final uri = Uri.https('api.spoonacular.com', '/recipes/$recipeId/information', {
      'includeNutrition': 'true',
      'apiKey': apiKey,
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return RecipeModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch recipe details: ${response.statusCode}");
    }
  }

  Future<List<dynamic>> getAnalyzedInstructions(int recipeId) async {
    final uri = Uri.https('api.spoonacular.com', '/recipes/$recipeId/analyzedInstructions', {
      'apiKey': apiKey,
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Failed to fetch analyzed instructions: ${response.statusCode}");
    }
  }

  Future<List<RecipeModel>> fetchRandomRecipes({int number = 10}) async {
    final uri = Uri.https('api.spoonacular.com', '/recipes/random', {
      'number': number.toString(),
      'apiKey': apiKey,
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['recipes'] ?? [];
      return results.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch random recipes: ${response.statusCode}");
    }
  }
}



