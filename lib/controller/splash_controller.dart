import 'dart:async';
import 'dart:ui';
import 'package:chatBot/controller/home_controller.dart';
import '../helper/local_storage.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../utils/constants.dart';

class SplashController extends GetxController {
  final homeController = Get.put(HomeController());

  @override
  void onInit() {
    homeController.getCredentials();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    var languageList = LocalStorage.getLanguage();
    var locale = Locale(languageList[0], languageList[1]);
    languageStateName = languageList[2];
    Get.updateLocale(locale);
    _goToScreen();
  }

  _goToScreen() async {
    Timer(const Duration(seconds: 4), () {
      LocalStorage.isLoggedIn()
          ? LocalStorage.showAdPermissioned()
              ? Get.offAndToNamed(Routes.purchasePlanScreen)
              : Get.offAndToNamed(Routes.homeScreen)
          : Get.offAndToNamed(Routes.loginScreen);
    });
  }
}
