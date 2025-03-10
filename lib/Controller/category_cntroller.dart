import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:receipe_app_getxstate/Model/category_model.dart';
import 'package:receipe_app_getxstate/Model/meal_model.dart';





class CategoryController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchCategory();
  }

  var categoryList = <CategoryModel>[].obs;
  var isLoading = true.obs;
  var isSearchLoading=true.obs;

  var meallist=<MealModel>[].obs;

  Future<void> fetchCategory() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['categories'];
      categoryList.value=data.map((e) => CategoryModel.fromJson(e)).toList();
      isLoading.value = false;
      update();
    } else {
      Get.snackbar("Error Loading data!", "Server Responded:${response.reasonPhrase.toString()}");
    }

  }

  Future<void> SearchMeal(String query) async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'));
    if (response.statusCode == 200) {
      final  data = json.decode(response.body)['meals'];
      if(data!=null){
        meallist.value=List<MealModel>.from(data.map((e) => MealModel.fromJson(e)));
        isSearchLoading.value=false;
      }else{
        meallist.clear();
      }
    } else {
      Get.snackbar("Error Loading data!", "Server Responded:${response.reasonPhrase.toString()}");
    }
  }
}
