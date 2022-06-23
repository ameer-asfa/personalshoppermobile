import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personalshopper/components/product_card.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/apiConstant.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/models/Shopper.dart';
import 'package:personalshopper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final double _topContainer = 190.00;

  late List<Product> productModel;
  late Shopper shopperModel;
  bool isLoading = true;

  Future<String> getShopperId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? '';
  }

  Future getInfo(id) async {
    final responseProduct = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/product/shopper/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    final responseShopper = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/profile/shopper/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    var parseProduct = await json.decode(responseProduct.body);
    var parseShopper = await json.decode(responseShopper.body);
    shopperModel = Shopper.fromJson(parseShopper);
    productModel = List<Product>.from(
        parseProduct.map((model) => Product.fromJson(model)));

    Future.delayed(Duration.zero, () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getShopperId().then((id) => getInfo(id));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Container(
                height: _topContainer,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: _topContainer * 0.52,
                          color: Colors.grey[700],
                        ),
                        Container(
                          height: _topContainer * 0.48,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Container(
                        height: 110,
                        width: 110,
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/Man.png'),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 150,
                      child: Text(shopperModel.name!,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 147,
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          Text(
                            shopperModel.state!,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              productModel.length < 1
                  ? SizedBox()
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: GridView.builder(
                          itemCount: productModel.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) => ProductCard(
                              product: productModel[index], press: () {}),
                        ),
                      ),
                    ),
            ],
          );
  }
}
