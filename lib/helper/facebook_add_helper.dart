import 'dart:io';

import '../utils/dimensions.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';

class FacebookAdHelper{

  static initialization(){
    FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
      // testingId: "a77955ee-3304-4635-be65-81029b0f5201", //optional
      iOSAdvertiserTrackingEnabled: true //default false
    );
  }

  static Widget getBannerAd(){

    Widget bannerAd = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.widthSize * 3,
      ),
      child: FacebookBannerAd(
        placementId: Platform.isAndroid
            ? "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID"
            : "YOUR_IOS_PLACEMENT_ID",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          switch (result) {
            case BannerAdResult.ERROR:
            // print("Error: $value");
            break;
            case BannerAdResult.LOADED:
            // print("Loaded: $value");
            break;
            case BannerAdResult.CLICKED:
            // print("Clicked: $value");
            break;
            case BannerAdResult.LOGGING_IMPRESSION:
            // print("Logging Impression: $value");
            break;
          }
        }
  ),
    );

    return bannerAd;
  }

  static initAd(){
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd(delay: 5000);
        }
      },
    );
  }
}