import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const String idKey = "idKey";
const String lastPressed = "lastPressed";
const String nameKey = "nameKey";

const String tokenKey = "tokenKey";

const String emailKey = "emailKey";

const String imageKey = "imageKey";

const String showAdKey = "showAdKey";
const String chatGptApiKey = "chatGptApiKey";
const String paypalClientId = "paypalClientId";
const String paypalSecret = "paypalSecret";
const String textCount = "textCount";
const String imageCount = "imageCount";
const String adCount = "adCount";
const String isLoggedInKey = "isLoggedInKey";
const String isPremium = "isPremium";
const String isFreeUserKey = "isFreeUserKey";
const String planExpiryDate = "planExpiryDate";
const String isDataLoadedKey = "isDataLoadedKey";

const String isOnBoardDoneKey = "isOnBoardDoneKey";

const String isScheduleEmptyKey = "isScheduleEmptyKey";

const String language = "language";
const String smallLanguage = "smallLanguage";
const String capitalLanguage = "capitalLanguage";
const String themeName = "themeName";

class LocalStorage {
  static Future<void> saveLanguage({
    required String langSmall,
    required String langCap,
    required String languageName,
  }) async {
    final box1 = GetStorage();
    final box2 = GetStorage();
    final box3 = GetStorage();

    var locale = Locale(langSmall, langCap);
    Get.updateLocale(locale);
    await box1.write(smallLanguage, langSmall);
    await box2.write(capitalLanguage, langCap);
    await box3.write(language, languageName);
  }

  static List getLanguage() {
    String small = GetStorage().read(smallLanguage) ?? 'en';
    String capital = GetStorage().read(capitalLanguage) ?? 'US';
    String languages = GetStorage().read(language) ?? 'English';
    return [small, capital, languages];
  }

  static savePlanExpiryDate(String planExpiry)async{
    final box = GetStorage();
    box.write(planExpiryDate, planExpiry);
  }

  static String getPlanExpiryDate(){
    final box = GetStorage();
    String date = box.read(planExpiryDate) ?? "2023-01-01";
    return date;
  }

  static savePremiumStatus(bool status)async{
    final box = GetStorage();
    box.write(isPremium, status);
  }

  static bool getPremiumStatus(){
    bool status = GetStorage().read(isPremium) ?? false;
    return status;
  }

  static int getAdCount(){
    int ac = GetStorage().read(adCount) ?? 0;
    return ac;
  }

  static saveAdCount(int value) async{
    final box = GetStorage();
    await box.write(adCount, value);
  }

  static String getLastPressed(){
    String lp = GetStorage().read(lastPressed) ?? '2023-01-01';
    return lp;
  }

  static saveLastPressed(String lp) async{
    final box1 = GetStorage();
    await box1.write(lastPressed, lp);
  }

  static Future<void> saveTheme({
    required int themeStateName,
  }) async {
    final box1 = GetStorage();
    await box1.write(themeName, themeStateName);
  }

  static getThemeState() {
    return GetStorage().read(themeName) ?? 0;
  }

  static Future<void> saveId({required String id}) async {
    final box = GetStorage();

    await box.write(idKey, id);
  }

  static Future<void> saveName({required String name}) async {
    final box = GetStorage();

    await box.write(nameKey, name);
  }

  static Future<void> saveEmail({required String email}) async {
    final box = GetStorage();

    await box.write(emailKey, email);
  }

  static Future<void> saveToken({required String token}) async {
    final box = GetStorage();

    await box.write(tokenKey, token);
  }

  static Future<void> saveImage({required String image}) async {
    final box = GetStorage();

    await box.write(imageKey, image);
  }

  static Future<void> isLoginSuccess({required bool isLoggedIn}) async {
    final box = GetStorage();

    await box.write(isLoggedInKey, isLoggedIn);
  }

  static Future<void> dataLoaded({required bool isDataLoad}) async {
    final box = GetStorage();

    await box.write(isDataLoadedKey, isDataLoad);
  }

  static Future<void> scheduleEmpty({required bool isScheduleEmpty}) async {
    final box = GetStorage();

    await box.write(isScheduleEmptyKey, isScheduleEmpty);
  }

  static Future<void> showAdYes({required bool isShowAdYes}) async {
    final box = GetStorage();
    await box.write(showAdKey, isShowAdYes);
  }

  static Future<void> saveChatGptApiKey({required String key}) async {
    final box = GetStorage();
    await box.write(chatGptApiKey, key);
  }

  static Future<void> savePaypalClientId(
      {required String key}) async {
    final box = GetStorage();
    await box.write(paypalClientId, key);
  }

  static Future<void> savePaypalSecret({required String key}) async {
    final box = GetStorage();
    await box.write(paypalSecret, key);
  }

  static Future<void> saveTextCount({required int count}) async {
    final box = GetStorage();
    await box.write(textCount, count);
  }
  static Future<void> saveImageCount({required int count}) async {
    final box = GetStorage();
    await box.write(imageCount, count);
  }

  static Future<void> saveOnboardDoneOrNot(
      {required bool isOnBoardDone}) async {
    final box = GetStorage();

    await box.write(isOnBoardDoneKey, isOnBoardDone);
  }

  static Future<void> saveFreeUserOrNot({required bool isFreeUser}) async {
    final box = GetStorage();

    await box.write(isFreeUserKey, isFreeUser);
  }

  static String? getId() {
    return GetStorage().read(idKey);
  }

  static String? getName() {
    return GetStorage().read(nameKey);
  }

  static String? getChatGptApiKey() {
    return GetStorage().read(chatGptApiKey);
  }

  static String? getPaypalClientId() {
    return GetStorage().read(paypalClientId);
  }

  static String? getPaypalSecret() {
    return GetStorage().read(paypalSecret);
  }

  static int getTextCount() {
    return GetStorage().read(textCount)?? 0;
  }
  static int getImageCount() {
    return GetStorage().read(imageCount) ?? 0;
  }

  static String? getEmail() {
    return GetStorage().read(emailKey);
  }

  static String? getToken() {
    var rtrn = GetStorage().read(tokenKey);

    debugPrint(rtrn == null ? "##Token is null###" : "");

    return rtrn;
  }

  static String? getImage() {
    return GetStorage().read(imageKey);
  }

  static bool isLoggedIn() {
    return GetStorage().read(isLoggedInKey) ?? false;
  }

  static bool isDataloaded() {
    return GetStorage().read(isDataLoadedKey) ?? false;
  }

  static bool isScheduleEmpty() {
    return GetStorage().read(isScheduleEmptyKey) ?? false;
  }

  static bool isOnBoardDone() {
    return GetStorage().read(isOnBoardDoneKey) ?? false;
  }

  static bool isFreeUser() {
    return GetStorage().read(isFreeUserKey) ?? false;
  }

  static bool showAdPermissioned() {
    return GetStorage().read(showAdKey) ?? false;//should be false by default, was true
  }

  static String? get() {
    return GetStorage().read(nameKey);
  }

  static Future<void> logout() async {
    final box = GetStorage();

    await box.remove(idKey);

    await box.remove(nameKey);

    await box.remove(emailKey);

    await box.remove(imageKey);

    await box.remove(isLoggedInKey);

    await box.remove(isOnBoardDoneKey);

    await box.remove(isFreeUserKey);
  }
}
