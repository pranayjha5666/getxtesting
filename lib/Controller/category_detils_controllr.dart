import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:receipe_app_getxstate/Model/category_details_model.dart';

class CategoryDetailsController extends GetxController {
  final String category;

  CategoryDetailsController(this.category);

  var meallist = <CategoryDetailsModel>[].obs;
  var isLoading = true.obs;


  @override
  void onInit() {
    fetchMealsList(category);
    super.onInit();
  }
  Future<void> fetchMealsList(String category) async {
    final response = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['meals'];
      meallist.value=List<CategoryDetailsModel>.from(data.map((e) => CategoryDetailsModel.fromJson(e)));
      isLoading.value = false;
      update();
    } else {
      Get.snackbar("Error Loading data!", "Server Responded:${response.reasonPhrase.toString()}");
    }
  }
}
