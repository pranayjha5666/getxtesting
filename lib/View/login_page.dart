// login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receipe_app_getxstate/Common/widget/custombutton.dart';
import 'package:receipe_app_getxstate/Common/widget/customtextformfield.dart';
import 'package:receipe_app_getxstate/Controller/auth_controller.dart';
import 'package:receipe_app_getxstate/Controller/logincontroller.dart';

class Login extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(
                controller: controller.phoneController,
                hintText: "Enter Phone Number",
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 15),
              CustomButton(
                onTap: controller.signinWithPhone,
                text: "Login",
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: controller.signInWithGoogle,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Text(
                    "Continue With Google",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Outfit',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
