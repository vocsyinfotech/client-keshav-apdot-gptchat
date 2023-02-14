import 'dart:async';

import 'package:chatBot/utils/custom_color.dart';
import 'package:chatBot/utils/dimensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../widgets/api/toast_message.dart';

class InAppScreen extends StatefulWidget {
  const InAppScreen({Key? key}) : super(key: key);

  @override
  State<InAppScreen> createState() => _InAppScreenState();
}

class _InAppScreenState extends State<InAppScreen> {
  List<dynamic> idList = [];
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = true;

  List<ProductDetails> _products = <ProductDetails>[];

  // late StreamSubscription _subscription;

  Future<void> _getIds() async {
    var collection = FirebaseFirestore.instance.collection('products').doc("product-ids");
    final DocumentSnapshot snapshot = await collection.get();
    setState(() {
      idList = snapshot.get('ids');
      debugPrint("GOOGLE APP IN PURCHASE IDS ${snapshot.get('ids')}");
    });
  }

  void _initialize() async {
    _getIds().then((value) async {
      _available = await _iap.isAvailable();
      debugPrint("GOOGLE APP IN PURCHASE AVAILABLE $_available");
      if (_available) {
        await _getProducts();
      } else {
        ToastMessage.error("No product Available right now Try again later");
      }
    });
  }

  void buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from(idList);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
      debugPrint("GOOGLE APP IN PURCHASE PRODUCT LENGTH ${_products.length}");
    });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    // _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Purchase Screen',
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_products.length, (index) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(9),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize * 2, vertical: Dimensions.heightSize * 2),
              decoration: BoxDecoration(
                  color: CustomColor.secondaryColor2.withOpacity(Get.isDarkMode ? 0.03 : 1),
                  border: Border.all(width: 2, color: CustomColor.secondaryColor2.withOpacity(Get.isDarkMode ? 0.08 : 1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7 - 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _products[index].title,
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _products[index].description,
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${_products[index].price} Per Month",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3 - 30,
                    child: MaterialButton(
                      onPressed: () {
                        //place payment code here
                        ToastMessage.success("Initializing payment");
                        buyProduct(_products[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: const Text(
                          'Buy',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
