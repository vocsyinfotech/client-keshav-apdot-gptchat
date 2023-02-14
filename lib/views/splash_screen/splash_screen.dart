import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';

import '../../utils/assets.dart';
import '../../utils/constants.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlayAnimationBuilder(
              tween: Tween(begin: 0.2, end: 1.0),
              duration: const Duration(milliseconds: 2000),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Image.asset(
                      Assets.bot,
                      scale: 3,
                    ),
                  ),
                );
              },
            ),

            languageStateName == 'Arabic'
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
                            'bot'.substring(0, value),
                            style: TextStyle(
                                fontSize: Dimensions.defaultTextSize * 3.2, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
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
                            style:
                                TextStyle(fontSize: Dimensions.defaultTextSize * 3.2, fontWeight: FontWeight.w400, color: CustomColor.primaryColor),
                          );
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PlayAnimationBuilder(
                        tween: IntTween(begin: 0, end: 4),
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 200),
                        builder: (context, value, child) {
                          return Text(
                            'Chat'.substring(0, value),
                            style:
                                TextStyle(fontSize: Dimensions.defaultTextSize * 3.2, fontWeight: FontWeight.w400, color: CustomColor.primaryColor),
                          );
                        },
                      ),
                      PlayAnimationBuilder(
                        tween: IntTween(begin: 0, end: 3),
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 1200),
                        builder: (context, value, child) {
                          return Text(
                            'bot'.substring(0, value),
                            style: TextStyle(
                                fontSize: Dimensions.defaultTextSize * 3.2, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
                          );
                        },
                      ),
                    ],
                  ),
            // Container(
            //   height: MediaQuery.of(context).size.height*0.2,
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Text(
            //       'Powered by Gold VPN Network Ltd.',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 18,
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
