import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:receipe_app_getxstate/Common/widget/custombutton.dart';
import 'package:receipe_app_getxstate/Controller/meal_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MealPage extends StatelessWidget {
  final String? mealid;
  const MealPage({super.key, required this.mealid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<MealController>(MealController(mealid!));
    final GlobalKey globalKey = GlobalKey();

    Future<void> captureScreenShot() async {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
      Uint8List pngBytes = byteData.buffer.asUint8List();
      await Share.shareXFiles([
        XFile.fromData(pngBytes, mimeType: 'image/png'),
      ]);
    }

    Widget buildMealContent() {
      final meal = controller.meal.value;
      return RepaintBoundary(
        key: globalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal!.strMealThumb),
            const SizedBox(height: 15),
            Text(
              meal.strMeal,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${meal.strCategory}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Area: ${meal.strArea}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (meal.strTags.isNotEmpty)
              Text(
                'Tags: ${meal.strTags}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(meal.strInstructions),
            const SizedBox(height: 20),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meal.ingredients.length,
              itemBuilder: (context, index) {
                return Table(
                  border: TableBorder.all(width: 1.0, color: Colors.black),
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(meal.ingredients[index]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(meal.measures[index]),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            if (meal.strYoutube.isNotEmpty)
              CustomButton(
                onTap: () {
                  launchUrl(Uri.parse(meal.strYoutube));
                },
                text: "Youtube Video",
              ),
            const SizedBox(height: 10),
            CustomButton(onTap: captureScreenShot, text: "Share"),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return mealid != ""
              ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics:
                    const AlwaysScrollableScrollPhysics(), // important for RefreshIndicator
                child: buildMealContent(),
              )
              : RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchRandomMeal();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics:
                      const AlwaysScrollableScrollPhysics(), // important for RefreshIndicator
                  child: buildMealContent(),
                ),
              );
        }),
      ),
    );
  }
}
