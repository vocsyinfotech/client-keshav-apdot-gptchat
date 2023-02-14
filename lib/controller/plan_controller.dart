import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../helper/local_storage.dart';
import '../routes/routes.dart';
import '../widgets/api/toast_message.dart';

class PlanController extends GetxController {
  RxString prise = '9'.obs;

  // join meeting
  final paypalController = TextEditingController();
  final stripeController = TextEditingController();
  final nameOnCardController = TextEditingController();
  final cardNumberController = TextEditingController();
  final dateController = TextEditingController();
  final cvvOrCvcController = TextEditingController();
  final mmOrYyyyController = TextEditingController();

  removePremium() async {
    LocalStorage.savePlanExpiryDate("2023-01-01");
    LocalStorage.savePremiumStatus(false);
    var collection = FirebaseFirestore.instance.collection('adbotUsers');
    collection.doc(LocalStorage.getId()).update({
      'isPremium': false,
      'planExpiryDate': "2023-01-01",
    });
  }

  updateUserPlan() async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    DateTime curr = DateFormat().parse(formattedDate);
    DateTime planExpiry = curr.add(const Duration(days: 30));
    String expiry = formatter.format(planExpiry);
    var collection = FirebaseFirestore.instance.collection('adbotUsers');
    collection.doc(LocalStorage.getId()).update({
      'isPremium': true,
      'planExpiryDate': expiry,
    });
    LocalStorage.savePlanExpiryDate(expiry);
    ToastMessage.success('Your Plan Updated to Premium');
    LocalStorage.savePremiumStatus(true);
    LocalStorage.showAdYes(isShowAdYes: false);
    Get.offNamedUntil(Routes.homeScreen, (route) => false);
  }

  @override
  void dispose() {
    paypalController.dispose();
    stripeController.dispose();
    nameOnCardController.dispose();
    cardNumberController.dispose();
    dateController.dispose();
    cvvOrCvcController.dispose();
    mmOrYyyyController.dispose();

    super.dispose();
  }

  navigateToDashboardScreen() {
    Get.toNamed(Routes.homeScreen);
  }
}
