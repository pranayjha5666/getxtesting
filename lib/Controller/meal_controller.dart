import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:receipe_app_getxstate/Model/meal_model.dart';



class MealController extends GetxController{

  final String mealid;


  MealController(this.mealid);

  var meal = Rxn<MealModel>();
  var isLoading = true.obs;

  @override
  void onInit() {
    if (mealid != "") {
      fetchMeals(mealid!);
    } else {
      fetchRandomMeal();
    }
    super.onInit();
  }

  Future<void> fetchMeals(String mealid) async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealid'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'][0];
      meal.value = MealModel.fromJson(data);
    } else {
      Get.snackbar("Error", "Server error: ${response.reasonPhrase}");
    }
    isLoading.value = false;
  }

  Future<void> fetchRandomMeal() async {
    isLoading.value = true;
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'][0];
      meal.value = MealModel.fromJson(data);
    } else {
      Get.snackbar("Error", "Server error: ${response.reasonPhrase}");
    }
    isLoading.value = false;
  }
}
