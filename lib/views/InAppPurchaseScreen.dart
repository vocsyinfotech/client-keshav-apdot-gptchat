import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  late StreamSubscription _subscription;

  Future<void> _getIds() async {
    var collection = FirebaseFirestore.instance.collection('products').doc("product-ids");
    final DocumentSnapshot snapshot = await collection.get();
    print('=====Id===== 00  ${snapshot.get('ids')}');
    setState(() {
      idList = snapshot.get('ids');
      print('=====Id===== 11 ${idList.length}');
    });
  }

  void _initialize() async {
    _getIds().then((value) async {
      _available = await _iap.isAvailable();
      print('=====Id===== 33  $_available');
      if (_available) {
        await _getProducts();
      } else {
        ToastMessage.error("No product Available right now Try again later");
      }
    });
  }

  void buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from(idList);
    print('=====Id===== 44 ${ids.toSet()}');
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    print('=====Id===== 55 ${response.productDetails}');

    setState(() {
      _products = response.productDetails;
      print('=====Id===== 66 ${_products.length}');
    });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Purchase Screen',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_products.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                elevation: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7 - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _products[index].title ?? "Item",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              _products[index].description ?? "Description",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "\$ ${_products[index].price ?? "Price"} per Month",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3 - 20,
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
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
