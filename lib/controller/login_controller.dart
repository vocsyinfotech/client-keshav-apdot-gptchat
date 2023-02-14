import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/local_storage.dart';
import '../model/user_model/user_model.dart';
import '../routes/routes.dart';
import '../widgets/api/logger.dart';
import '../widgets/api/toast_message.dart';

final log = logger(LoginController);

class LoginController extends GetxController {
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  final FirebaseAuth _auth = FirebaseAuth.instance; // firebase instance/object

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // getting user auth status
  Stream<User?> get authChanges => _auth.authStateChanges();

  // getter for our user to access the user data from outside using this authChange getter
  User get user => _auth.currentUser!;

  // sign in with google account function
  // this function will return a boolean value
  Future<bool> signInWithGoogle(BuildContext context) async {
    bool result = false;
    try {
      _isLoading.value = true;
      update();
      // getting google user
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // taking google auth with the authentication
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if (googleAuth == null) {
        _isLoading.value = false;
        update();
      }
      // taking the credential of the user
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, // accessToken from google auth
        idToken: googleAuth?.idToken, // idToken from google auth
      );

      // user credential to use the firebase credential and sign in with the google account
      // also after this line of code the data will be reflected in the fireStore database
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Get the user form the firebase
      User? user = userCredential.user;

      if (user != null) {
        // storing some data for future use
        ToastMessage.success("Login Success");
        LocalStorage.saveAdCount(0);
        LocalStorage.isLoginSuccess(isLoggedIn: true);
        LocalStorage.saveEmail(email: user.email!);
        LocalStorage.saveName(name: user.displayName ?? "");
        LocalStorage.saveLastPressed("2023-01-01");
        // LocalStorage.savePhoneNumber(phoneNumber: user.phoneNumber ?? "");
        LocalStorage.saveId(id: user.uid);
        UserModel userData = UserModel(
            name: user.displayName ?? "",
            uniqueId: user.uid,
            email: user.email!,
            phoneNumber: user.phoneNumber ?? "",
            isActive: true,
            imageUrl: user.photoURL ?? "",
            isPremium: false,
            textCount: 0,
            imageCount: 0,
            planExpiryDate: "2023-01-01");

        if (userCredential.additionalUserInfo!.isNewUser) {
          await _fireStore.collection('adbotUsers').doc(user.uid).set(userData.toJson());
          _isLoading.value = false;
          update();
          Get.offAllNamed(Routes.purchasePlanScreen);
        } else {
          /// check free or premium
          final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('adbotUsers').doc(user.uid).get();
          String expiry = userDoc.get('planExpiryDate');
          LocalStorage.savePlanExpiryDate(expiry);
          if (userDoc.get('isPremium')) {
            LocalStorage.saveTextCount(count: userDoc.get('textCount'));
            LocalStorage.showAdYes(isShowAdYes: !userDoc.get('isPremium'));
            LocalStorage.savePremiumStatus(userDoc.get('isPremium'));
            Get.offAllNamed(Routes.homeScreen);
          } else {
            LocalStorage.saveTextCount(count: userDoc.get('textCount'));
            Get.offAllNamed(Routes.purchasePlanScreen);
          }

          _isLoading.value = false;
          update();
        }

        result = true;
      } else {
        _isLoading.value = false;
        update();
      }
    } on FirebaseAuthException catch (e) {
      log.e("🐞🐞🐞 Printing Error FirebaseAuthException => ${e.message!}  🐞🐞🐞");
      ToastMessage.error(e.message!);
      _isLoading.value = false;
      update();
      result = false;
    } on PlatformException catch (e) {
      _isLoading.value = false;
      update();
      log.e("🐞🐞🐞 Printing Error PlatformException => ${e.message!}  🐞🐞🐞");
    }
    _isLoading.value = false;
    update();
    return result;
  }

  void goToHomePage() {
    Get.toNamed(Routes.homeScreen);
  }
}
