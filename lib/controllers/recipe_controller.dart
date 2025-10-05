import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_first_app/services/recipe_model.dart';
import 'package:my_first_app/services/recipe_service.dart';

class RecipeController extends GetxController {
  final RecipeService _service = RecipeService();
  final GetStorage _box = GetStorage();

  final rxRecipes = <RecipeModel>[].obs;
  final favorites = <RecipeModel>[].obs;
  final isLoading = false.obs;
  final selectedCuisine = 'Indian'.obs;

  static const String _favKey = 'fav_recipes';

  @override
  void onInit() {
    super.onInit();
    _loadFavoritesFromStorage();
    fetchRecipes();
  }

  Future<void> fetchRecipes({String query = '', int number = 10, int offset = 0}) async {
    try {
      isLoading.value = true;
      final data = await _service.getRecipeByQuery(
        query,
        number: number,
        offset: offset,
        cuisine: selectedCuisine.value,
      );
      rxRecipes.assignAll(data);
    } catch (e) {
      rxRecipes.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchByIngredients(List<String> ingredients) async {
    try {
      isLoading.value = true;
      final data = await _service.getRecipesByIngredients(ingredients, number: 10);
      rxRecipes.assignAll(data);
    } catch (e) {
      rxRecipes.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavoriteId(int id) => favorites.any((r) => r.id == id);

  void toggleFavorite(RecipeModel r) {
    if (isFavoriteId(r.id)) {
      favorites.removeWhere((x) => x.id == r.id);
    } else {
      favorites.add(r);
    }
    _saveFavoritesToStorage();
  }

  void _saveFavoritesToStorage() {
    final list = favorites.map((r) => r.toJson()).toList();
    _box.write(_favKey, list);
  }

  void _loadFavoritesFromStorage() {
    final data = _box.read<List<dynamic>>(_favKey);
    if (data != null && data.isNotEmpty) {
      final loaded = data.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        return RecipeModel.fromJson(map);
      }).toList();
      favorites.assignAll(loaded);
    } else {
      favorites.clear();
    }
  }
}
