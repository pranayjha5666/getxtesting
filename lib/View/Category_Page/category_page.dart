import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:receipe_app_getxstate/Common/widget/custombutton.dart';
import 'package:receipe_app_getxstate/Common/widget/customtextformfield.dart';
import 'package:receipe_app_getxstate/Model/category_model.dart';
import 'package:receipe_app_getxstate/View/CategoryDetailsPage/category_details_page.dart';
import 'package:receipe_app_getxstate/View/MealPage/meal_page.dart';
import 'package:receipe_app_getxstate/View/login_page.dart';

import '../../Controller/category_cntroller.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchcontroller = TextEditingController();

    final controller = Get.put<CategoryController>(CategoryController());
    List<CategoryModel> _categorylist = controller.categoryList;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _searchcontroller,
                      hintText: 'Search Meal',
                      prefixIcon: Icons.search,
                      onChanged: (query) async {
                        if (query.trim().isNotEmpty) {
                          await controller.SearchMeal(query.trim());
                        } else {
                          controller.meallist
                              .clear(); // clear results if input is empty
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.to(MealPage(mealid: "",));
                      },
                      icon: Icon(Icons.refresh),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () =>
                      controller.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : controller.meallist.isNotEmpty
                          ? ListView.builder(
                            itemCount: controller.meallist.length,
                            itemBuilder: (context, index) {
                              final meal = controller.meallist[index];
                              return GestureDetector(
                                onTap: (){
                                  Get.to(MealPage(mealid: meal.idMeal));

                                },
                                  child: ListTile(title: Text(meal.strMeal)));
                            },
                          )
                          : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 0,
                                ),
                            itemCount: _categorylist.length,
                            itemBuilder: (context, index) {
                              final category = _categorylist[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(CategoryDetailsPage(category: category.strCategory));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      category.strCategoryThumb,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      category.strCategory,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),

              ),
              CustomButton(onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.to(Login());
              }, text: "Logout")
            ],
          ),
        ),
      ),
    );
  }
}
