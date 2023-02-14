import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controller/chat_controller.dart';
import '../helper/admob_helper.dart';
import '../helper/local_storage.dart';
import '../utils/custom_color.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../widgets/api/custom_loading_api.dart';
import '../widgets/api/toast_message.dart';
import '../widgets/appbar/appbar_widget.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/inputs_widgets/send_input_field.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.speechStopMethod();
        return true;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          context: context,
          onBackClick: () {
            controller.speechStopMethod();
            Get.back();
          },
          list: controller.moreList,
          appTitle: "Chat with ChatGPT",
          onPressed: () {
            _showDialog(context);
          },
        ),
        body: _mainBody(context),
      ),
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
              SizedBox(height: 10),
            ],
          ),
        ));
  }

  _mainBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _adShowWidget(),
        Expanded(
          flex: 5,
          child: _buildList(),
        ),
        Expanded(
          flex: 0,
          child: Obx(() => Visibility(visible: controller.isLoading.value, child: const CustomLoadingAPI())),
        ),
        Expanded(flex: 0, child: _submitButton(context)),
        SizedBox(height: Dimensions.heightSize)
      ],
    );
  }

  _submitButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SendInputField(
        icon: Animator<double>(
            duration: const Duration(milliseconds: 1000),
            cycles: 0,
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 15.0, end: 25.0),
            builder: (context, animatorState, child) => Obx(() => Icon(Icons.mic_none_sharp,
                size: animatorState.value,
                color: controller.isListening.value ? CustomColor.primaryColor : Theme.of(context).primaryColor.withOpacity(0.5)))),
        hintText: Strings.typeYour.tr,
        onTap: () {
          if (LocalStorage.showAdPermissioned()) {
            if (controller.chatController.text.isNotEmpty) {
              controller.proccessChat();
              Future.delayed(const Duration(milliseconds: 50)).then((_) => controller.scrollDown());
            } else {
              ToastMessage.error(Strings.writeSomethingg.tr);
            }
          } else {
            //old value was 50
            if (controller.count.value <= 5) {
              debugPrint(controller.count.value.toString());
              if (controller.chatController.text.isNotEmpty) {
                controller.proccessChat();
                Future.delayed(const Duration(milliseconds: 50)).then((_) => controller.scrollDown());
              } else {
                ToastMessage.error(Strings.writeSomethingg.tr);
              }
            } else {
              debugPrint(controller.count.value.toString());
              ToastMessage.error('Chat Limit is over. Buy subscription.');
            }
          }
        },
        voiceTab: () {
          controller.listen(context);
        },
        controller: controller.chatController,
      ),
    );
  }

  _buildList() {
    var languageList = LocalStorage.getLanguage();
    return Obx(() => ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.itemCount.value,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ChatMessageWidget(
                onStop: () {
                  controller.speechStopMethod();
                },
                onSpeech: () {
                  controller.speechMethod(controller.messages.value[index].text, '${languageList[0]}-${languageList[1]}');
                  controller.voiceSelectedIndex.value = index;
                },
                text: controller.messages.value[index].text,
                chatMessageType: controller.messages.value[index].chatMessageType,
                index: index);
          },
        ));
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize * 3, vertical: Dimensions.heightSize),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                  controller.moreList.length,
                  (index) => Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize * 1, vertical: Dimensions.heightSize * 0.5),
                        child: TextButton(
                            onPressed: () {
                              /*if (LocalStorage.showAdPermissioned()) {
                                FacebookAdHelper.initAd();
                              }*/
                              if (index == 0) {
                                if (controller.textInput.value.isNotEmpty) {
                                  controller.proccessChat2();
                                }
                              } else if (index == 1) {
                                controller.clearConversation();
                              } else if (index == 2) {
                                if (controller.shareMessages.isEmpty) {
                                  Get.snackbar('OH No!!', 'No Conversation yet');
                                  Get.back();
                                } else {
                                  controller.shareChat(context);
                                }
                              }

                              Get.back();
                            },
                            child: Text(
                              controller.moreList[index],
                              style: const TextStyle(color: CustomColor.blackColor),
                            )),
                      )),
            ),
          );
        });
  }
}
