
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:receipe_app_getxstate/View/Category_Page/category_page.dart';
import 'package:receipe_app_getxstate/View/login_page.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> _user = Rxn<User>();

  @override
  void onInit() {
    _user.bindStream(_auth.authStateChanges());
    ever(_user, _setInitialScreen);
    super.onInit();
  }

  _setInitialScreen(User? user) async {
    await Future.delayed(Duration.zero);

    if (user == null) {
      Get.offAll(() =>  Login());
    } else {
      Get.offAll(() =>  CategoryPage());
    }
  }


  bool get isLoggedIn => _auth.currentUser != null;
}
