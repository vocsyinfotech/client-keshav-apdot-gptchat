import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

String bannerAndroid = "";
String bannerIos = "";
String interstitialAndroid = "";
String interstitialIos = "";
String rewardedAndroid = "";
String rewardedIos = "";

class UnitIdHelper {
  getAdsId() async {
    var bannerCollection = FirebaseFirestore.instance.collection('admobid').doc("bannerads");
    final DocumentSnapshot bannerSnapshot = await bannerCollection.get();
    var rewardedCollection = FirebaseFirestore.instance.collection('admobid').doc("rewardedAd");
    final DocumentSnapshot rewardedSnapshot = await rewardedCollection.get();
    var interstitialCollection = FirebaseFirestore.instance.collection('admobid').doc("interstitialAd");
    final DocumentSnapshot interstitialSnapshot = await interstitialCollection.get();

    bannerAndroid = bannerSnapshot.get('bannerAndroid') ?? "";
    bannerIos = bannerSnapshot.get('bannerIos') ?? "";

    rewardedAndroid = rewardedSnapshot.get('rewardedAndroid') ?? "";
    rewardedIos = rewardedSnapshot.get('rewardedIos') ?? "";

    interstitialAndroid = interstitialSnapshot.get('interstitialAndroid') ?? "";
    interstitialIos = interstitialSnapshot.get('interstitialIos') ?? "";
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // ignore: deprecated_member_use
      return rewardedAndroid;
      // return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      // ignore: deprecated_member_use
      return rewardedIos;
      // return 'ca-app-pub-3940256099942544/1712485313';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // ignore: deprecated_member_use
      return bannerAndroid;
      // return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      // ignore: deprecated_member_use
      return bannerIos;
      // return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // adUnitId: Platform.isAndroid
  // ? "ca-app-pub-3940256099942544/6300978111"
  //     : " 	ca-app-pub-3940256099942544/2934735716",

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // ignore: deprecated_member_use
      return interstitialAndroid;
      // return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      // ignore: deprecated_member_use
      return interstitialIos;
      // return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
