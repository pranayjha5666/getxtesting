import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:receipe_app_getxstate/Common/widget/otp.dart';
import 'package:receipe_app_getxstate/View/Category_Page/category_page.dart';


class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signinWithPhone() async {
    final String phoneNumber = "+91${phoneController.text.trim()}";
    final TextEditingController codeController = TextEditingController();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.off(CategoryPage());

          // Get.offAllNamed(Home_Page.routeName);
        },
        verificationFailed: (e) {
          Get.snackbar("Error", e.message ?? "Verification Failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          showOTPDialog(
            context: Get.context!,
            codeController: codeController,
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: codeController.text.trim(),
                );
                await _auth.signInWithCredential(credential);
                Get.off(CategoryPage());
                // Get.offAllNamed(Home_Page.routeName);
              } catch (e) {
                Get.back();
                Get.snackbar("Invalid OTP", "Please try again");
              }
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();

      if (gUser == null) return;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        Get.off(CategoryPage());

        // Get.offAllNamed(Home_Page.routeName);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  String getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return 'Invalid email address or password.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
