import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/local_storage.dart';
import '../utils/constants.dart';
import '../utils/language/english.dart';
import '../utils/strings.dart';

class HomeController extends GetxController {
  var selectedLanguage = "".obs;

  @override
  void onInit() {
    selectedLanguage.value = languageStateName;
    getCredentials();
    super.onInit();
  }

  void getCredentials() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('credentials')
        .doc('manage-api-key')
        .get();

    LocalStorage.saveChatGptApiKey(key: userDoc.get('chat-gpt-api-key'));
    LocalStorage.savePaypalClientId(key: userDoc.get('paypal-client-id'));
    LocalStorage.savePaypalSecret(key: userDoc.get('paypal-secret'));

    debugPrint("""
        Get ChatGpt Api Key ↙️
        ${LocalStorage.getChatGptApiKey()},
        Get Paypal ClientId ↙️
        ${LocalStorage.getPaypalClientId()},
        Get Paypal Secret ↙️
        ${LocalStorage.getPaypalSecret()},
        """);
  }

  onChangeLanguage(var language, int index) {
    selectedLanguage.value = language;
    if (index == 0) {
      LocalStorage.saveLanguage(
        langSmall: 'en',
        langCap: 'US',
        languageName: English.english,
      );
      languageStateName = English.english;
    } else if (index == 1) {
      LocalStorage.saveLanguage(
        langSmall: 'sp',
        langCap: 'SP',
        languageName: English.spanish,
      );
      languageStateName = English.spanish;
    } else if (index == 2) {
      LocalStorage.saveLanguage(
        langSmall: 'ar',
        langCap: 'AR',
        languageName: English.arabic,
      );
      languageStateName = English.arabic;
    }
  }

  final List<String> moreList = [
    Strings.english,
    Strings.spanish,
    Strings.arabic
  ];
}
