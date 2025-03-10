
class MealModel {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  final List<String> ingredients;
  final List<String> measures;
  final String strYoutube;
  final String strCategory;
  final String strArea;
  final String strTags;
  final String strSource;
  final String strImageSource;
  final String strCreativeCommonsConfirmed;
  final String dateModified;

  MealModel({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
    required this.ingredients,
    required this.measures,
    required this.strYoutube,
    required this.strCategory,
    required this.strArea,
    required this.strTags,
    required this.strSource,
    required this.strImageSource,
    required this.strCreativeCommonsConfirmed,
    required this.dateModified,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] ?? '';
      String measure = json['strMeasure$i'] ?? '';

      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure);
      }
    }

    return MealModel(
      idMeal: json['idMeal'] ?? "",
      strMeal: json['strMeal'] ?? "",
      strMealThumb: json['strMealThumb'] ?? "",
      strInstructions: json['strInstructions'] ?? "",
      ingredients: ingredients,
      measures: measures,
      strYoutube: json['strYoutube'] ?? "",
      strCategory: json['strCategory'] ?? "",
      strArea: json['strArea'] ?? "",
      strTags: json['strTags'] ?? "",
      strSource:  json['strSource']??'',
      strImageSource: json['strImageSource'] ??'',
      strCreativeCommonsConfirmed: json['strCreativeCommonsConfirmed'] ?? '',
      dateModified: json['dateModified'] ?? '',
    );
  }
}
