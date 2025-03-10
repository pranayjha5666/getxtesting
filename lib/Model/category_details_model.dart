class CategoryDetailsModel {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  CategoryDetailsModel({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailsModel(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
    );
  }
}
