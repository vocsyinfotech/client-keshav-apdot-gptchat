import 'package:chatBot/controller/plan_controller.dart';
import 'package:chatBot/widgets/api/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:simple_animations/simple_animations.dart';

import '../controller/chat_controller.dart';
import '../controller/home_controller.dart';
import '../helper/admob_helper.dart';
import '../helper/facebook_add_helper.dart';
import '../helper/local_storage.dart';
import '../helper/unit_id_helper.dart';
import '../routes/routes.dart';
import '../utils/Flutter%20Theam/themes.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../utils/custom_color.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());
  final chatController = Get.put(ChatController());
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addAds(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _rewardedAd?.dispose();
  }

  void _showAlertDialog(BuildContext context, String message, bool isTextSearch, bool isWatchingAd, int adValue, {String lastDate = "2023-01-01"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Attention',
            style: TextStyle(color: CustomColor.primaryColor),
          ),
          content: Text(message, style: TextStyle(color: CustomColor.primaryColor)),
          actions: <Widget>[
            //premium button
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(Routes.purchasePlanScreen);
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Buy Premium',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
            //watch Ad
            GestureDetector(
              onTap: () {
                addAds(true);
                Navigator.of(context).pop();
                if (isWatchingAd) {
                  LocalStorage.saveLastPressed(lastDate);
                  showRewardedAd(isTextSearch, adValue);
                } else {
                  ToastMessage.error("Ad limit exhausted for the day");
                }
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Watch Ad',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.video_collection_outlined,
                        color: Colors.white,
                      ),
                    ],
                  )),
            ),
            //cancel button
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        );
      },
    );
  }

  void addAds(bool rewardedAd) {
    if (rewardedAd) {
      loadRewardedAd();
    }
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: UnitIdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
        setState(() {
          _rewardedAd = ad;
        });
        print("Rewarded Loaded");
      }, onAdFailedToLoad: (LoadAdError error) {
        _rewardedAd = null;
        Get.toNamed(Routes.chatScreen);
        print("Rewarded failed Load $error");
      }),
    );
  }

  void showRewardedAd(bool isTextSearch, int adCount) async {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedAd ad) {},
          onAdDismissedFullScreenContent: (RewardedAd ad) {
            ad.dispose();
            loadRewardedAd();
          },
          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
            ad.dispose();
            //print("error on loading Ad" + error.message);
          });

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        //to update adCount here
        LocalStorage.saveAdCount(adCount + 1);
        if (isTextSearch) {
          Get.toNamed(Routes.chatScreen);
        } else {
          Get.toNamed(Routes.searchScreen);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    RxBool isDark = Get.isDarkMode.obs;
    Color backgroundColor = isDark.value ? CustomColor.whiteColor : CustomColor.primaryColor;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_pageIconAnTitle(), _buttonsWidget(context, backgroundColor), SizedBox(height: Dimensions.heightSize * 4)],
      ),
      floatingActionButton: _floatingActionButton(isDark),
    );
  }

  _floatingActionButton(RxBool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: FloatingActionButton(
        onPressed: () {
          Themes().switchTheme();
          isDark.value = !isDark.value;
        },
        backgroundColor: CustomColor.primaryColor,
        child: Obx(() => Icon(
              isDark.value ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: CustomColor.whiteColor,
              size: 35,
            )),
      ),
    );
  }

  List _dateDiff() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    String tmp = LocalStorage.getLastPressed();
    String expiry = LocalStorage.getPlanExpiryDate();
    int adValue = LocalStorage.getAdCount();
    DateTime last = DateFormat('yyyy-MM-dd').parse(tmp);
    DateTime curr = DateFormat('yyyy-MM-dd').parse(formattedDate);
    DateTime expiryDate = DateFormat('yyyy-MM-dd').parse(expiry);
    double diff = (curr.difference(last).inHours / 24);
    int diff2 = expiryDate.difference(curr).inDays;
    return [diff, curr.toString(), adValue, diff2];
  }

  _buttonsWidget(BuildContext context, backgroundColor) {
    return Column(
      children: [
        _buildContainer(context, backgroundColor,
            isPNG: true, title: Strings.chatWithChatBot, subTitle: Strings.chatWithChatBotSubTitle, iconPath: Assets.chat, onTap: () {
          List tmp = _dateDiff();
          double diff = tmp[0];
          String currDate = tmp[1];
          int adValue = tmp[2];
          int expiryDiff = tmp[3];
          if (LocalStorage.getPremiumStatus()) {
            //true means user is a premium
            if (expiryDiff <= 31) {
              //means plan has not expired
              Get.toNamed(Routes.chatScreen);
            } else {
              //plan has expired
              ToastMessage.error("Your plan has expired. Please purchase a new plan to continue");
              //update plan
              PlanController().removePremium();
            }
          } else {
            if (diff >= 1) //to place adCount condition as well
            {
              LocalStorage.saveAdCount(0);
              _showAlertDialog(
                context,
                "You can watch 2 ads a day or Buy Premium",
                true,
                true,
                adValue,
                lastDate: currDate,
              );
            } else {
              if (adValue < 2) {
                _showAlertDialog(
                  context,
                  "You can watch 2 ads a day or Buy Premium",
                  true,
                  true,
                  adValue,
                  lastDate: currDate,
                );
              } else {
                _showAlertDialog(context, "Wait a day to watch 2 ads a day or Buy Premium", true, false, adValue);
              }
            }
          }

          /*if(LocalStorage.showAdPermissioned()){
              print("ad permission present");
              Get.toNamed(Routes.chatScreen);
            }else{
              //old limit was set to 50
              if(LocalStorage.getTextCount() <=  5){
                print("moving to chat");
                Get.toNamed(Routes.chatScreen);
              }else{
                //to place a rewarded ad
                print("showing ad");
                _showAlertDialog(context, true);
                //showRewardedAd(true);
                //ToastMessage.error('Chat limit is over.\nBuy Subscription for continue');
              }
            }*/
        }),
        //image container
        _buildContainer(context, backgroundColor,
            title: Strings.generateAnyImage.tr, subTitle: Strings.generateAnyImageSubTitle.tr, iconPath: Assets.image, onTap: () {
          List tmp = _dateDiff();
          double diff = tmp[0];
          String currDate = tmp[1];
          int adValue = tmp[2];
          int expiryDiff = tmp[3];
          if (LocalStorage.getPremiumStatus()) {
            //true means user is a premium
            if (expiryDiff <= 31) {
              //means plan has not expired
              Get.toNamed(Routes.searchScreen);
            } else {
              //plan has expired
              ToastMessage.error("Your plan has expired. Please purchase a new plan to continue");
              //update plan
              PlanController().removePremium();
            }
          } else {
            if (diff >= 1) //to place adCount condition as well
            {
              LocalStorage.saveAdCount(0);
              _showAlertDialog(
                context,
                "You can watch 2 ads a day or Buy Premium",
                false,
                true,
                adValue,
                lastDate: currDate,
              );
            } else {
              if (adValue < 2) {
                _showAlertDialog(
                  context,
                  "You can watch 2 ads a day or Buy Premium",
                  false,
                  true,
                  adValue,
                  lastDate: currDate,
                );
              } else {
                _showAlertDialog(context, "Wait a day to watch 2 ads a day or Buy Premium", false, false, adValue);
              }
            }
          }
        }),
        GestureDetector(
          onTap: () {
            _showDialog(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize * 2, vertical: Dimensions.heightSize * 0.7),
            width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.symmetric(vertical: Dimensions.heightSize * 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(Dimensions.radius * 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(() => Text(
                      controller.selectedLanguage.value.tr,
                      style: TextStyle(fontSize: Dimensions.defaultTextSize * 1.8, fontWeight: FontWeight.w500, color: backgroundColor),
                    )),
                SizedBox(width: Dimensions.widthSize * .7),
                Icon(
                  Icons.arrow_drop_down,
                  color: backgroundColor,
                )
              ],
            ),
          ),
        ),
        _adShowWidget(),
      ],
    );
  }

  _adShowWidget() {
    RxBool visible = LocalStorage.showAdPermissioned().obs;
    return Obx(() => Visibility(
          visible: visible.value,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: AdWidget(
                  ad: AdMobHelper.getBannerAd()..load(),
                  key: UniqueKey(),
                ),
              ),
              SizedBox(height: Dimensions.heightSize * 2),
              SizedBox(
                height: 50,
                child: FacebookAdHelper.getBannerAd(),
              ),
            ],
          ),
        ));
  }

  _pageIconAnTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.bot,
          scale: 6,
        ),
        _animatedTextWidget(),
      ],
    );
  }

  _animatedTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: languageStateName == 'Arabic'
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlayAnimationBuilder(
                  tween: IntTween(begin: 0, end: 3),
                  duration: const Duration(milliseconds: 1000),
                  delay: const Duration(milliseconds: 1200),
                  builder: (context, value, child) {
                    return Text(
                      'GPT'.substring(0, value),
                      style: TextStyle(fontSize: Dimensions.defaultTextSize * 3, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
                    );
                  },
                ),
                PlayAnimationBuilder(
                  tween: IntTween(begin: 0, end: 4),
                  duration: const Duration(milliseconds: 1000),
                  delay: const Duration(milliseconds: 200),
                  builder: (context, value, child) {
                    return Text(
                      'Chat'.substring(0, value),
                      style: TextStyle(fontSize: Dimensions.defaultTextSize * 3, fontWeight: FontWeight.w400, color: CustomColor.primaryColor),
                    );
                  },
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayAnimationBuilder(
                  tween: IntTween(begin: 0, end: 4),
                  duration: const Duration(milliseconds: 1000),
                  delay: const Duration(milliseconds: 200),
                  builder: (context, value, child) {
                    return Text(
                      'Chat'.substring(0, value),
                      style: TextStyle(
                        fontSize: Dimensions.defaultTextSize * 6,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.primaryColor,
                      ),
                    );
                  },
                ),
                PlayAnimationBuilder(
                  tween: IntTween(begin: 0, end: 3),
                  duration: const Duration(milliseconds: 1000),
                  delay: const Duration(milliseconds: 1200),
                  builder: (context, value, child) {
                    return Text(
                      'GPT'.substring(0, value),
                      style: TextStyle(
                        fontSize: Dimensions.defaultTextSize * 6,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  _buildContainer(BuildContext context, backgroundColor,
      {required String title, required String subTitle, required VoidCallback onTap, required String iconPath, bool isPNG = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.all(Dimensions.defaultPaddingSize * 0.5),
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize * 0.8,
          horizontal: Dimensions.widthSize * 3,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius), border: Border.all(color: backgroundColor.withOpacity(0.4), width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: !isPNG,
              child: Expanded(
                  flex: 0,
                  child: SvgPicture.asset(
                    iconPath,
                    color: backgroundColor,
                  )),
            ),
            Visibility(
              visible: isPNG,
              child: Expanded(
                  flex: 0,
                  child: Image.asset(
                    iconPath,
                    color: backgroundColor,
                    scale: 18,
                  )),
            ),
            SizedBox(width: Dimensions.widthSize),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: backgroundColor, fontWeight: FontWeight.w600, fontSize: Dimensions.defaultTextSize * 2),
                  ),
                  SizedBox(height: Dimensions.heightSize * 0.5),
                  Text(
                    subTitle,
                    style:
                        TextStyle(color: backgroundColor.withOpacity(0.4), fontWeight: FontWeight.w500, fontSize: Dimensions.defaultTextSize * 1.2),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize * 3, vertical: Dimensions.heightSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  controller.moreList.length,
                  (index) => Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize * 1, vertical: Dimensions.heightSize * 0.5),
                        child: TextButton(
                            onPressed: () {
                              controller.onChangeLanguage(controller.moreList[index], index);
                              Get.back();
                            },
                            child: Text(
                              controller.moreList[index].tr,
                              style: TextStyle(
                                  color: controller.selectedLanguage.value == controller.moreList[index]
                                      ? CustomColor.primaryColor
                                      : CustomColor.blackColor),
                            )),
                      )),
            ),
          );
        });
  }
}
