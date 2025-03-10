import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:receipe_app_getxstate/Controller/category_detils_controllr.dart';
import 'package:receipe_app_getxstate/Model/category_details_model.dart';
import 'package:receipe_app_getxstate/View/MealPage/meal_page.dart';
class CategoryDetailsPage extends StatelessWidget {
  final String category;
  CategoryDetailsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<CategoryDetailsController>(CategoryDetailsController(category));
    List<CategoryDetailsModel> _meallist = controller.meallist;

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: _meallist.length,
            itemBuilder: (context, index) {
              final meal = _meallist[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Image.network(meal.strMealThumb, width: 100, height: 100, fit: BoxFit.cover),
                title: Text(meal.strMeal),
                onTap: () {
                  Get.to(MealPage(mealid: meal.idMeal,));
                },
              );
            },
          );
        }

      )
    );
  }
}
