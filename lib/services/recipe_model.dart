class RecipeModel {
  final int id;
  final String title;
  final String image;
  final int? likes;
  final String? summary;
  final String? instructions;
  final List<String>? ingredients;
  final double? readyInMinutes;
  final double? servings;
  final double? healthScore;

  RecipeModel({
    required this.id,
    required this.title,
    required this.image,
    this.likes,
    this.summary,
    this.instructions,
    this.ingredients,
    this.readyInMinutes,
    this.servings,
    this.healthScore,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    List<String>? ing;
    if (json['extendedIngredients'] != null) {
      ing = (json['extendedIngredients'] as List)
          .map((e) => e['originalString']?.toString() ?? '')
          .toList();
    } else if (json['missedIngredients'] != null ||
        json['usedIngredients'] != null) {
      final missed = (json['missedIngredients'] as List?)
          ?.map((e) => e['original']?.toString() ?? '')
          .toList() ??
          [];
      final used = (json['usedIngredients'] as List?)
          ?.map((e) => e['original']?.toString() ?? '')
          .toList() ??
          [];
      ing = [...missed, ...used];
    } else if (json['ingredients'] != null) {
      ing = (json['ingredients'] as List).map((e) => e.toString()).toList();
    }

    return RecipeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      likes: json['likes'] ?? json['aggregateLikes'],
      summary: json['summary'],
      instructions: json['instructions'],
      ingredients: ing,
      readyInMinutes: (json['readyInMinutes'] != null)
          ? (json['readyInMinutes'] as num).toDouble()
          : null,
      servings: (json['servings'] != null)
          ? (json['servings'] as num).toDouble()
          : null,
      healthScore: (json['healthScore'] != null)
          ? (json['healthScore'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'likes': likes,
    'summary': summary,
    'instructions': instructions,
    'ingredients': ingredients,
    'readyInMinutes': readyInMinutes,
    'servings': servings,
    'healthScore': healthScore,
  };
}
