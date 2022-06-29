import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:personalshopper/models/Products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:personalshopper/apiConstant.dart';

class ProductDetailsScreen extends StatefulWidget {
  static String routeName = "/productdetails";

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Product productModel;
  String? productId;
  bool isLoading = true;

  Future<String> _getId() async {
    var prefs = await SharedPreferences.getInstance();
    productId = prefs.getString('product_id');
    setState(() {
      productId = productId;
    });
    return productId!;
  }

  _getProductInfo(product_id) async {
    final response = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/product/' + product_id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));
    var parse = json.decode(response.body);
    setState(() {
      productModel = Product.fromJson(parse[0]);
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getId().then((product_id) => _getProductInfo(product_id));
  }

  @override
  Widget build(BuildContext context) {
    // final ProductDetailsArguments agrs =
    //     ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Color(0xFFF5F6F9),
            // appBar: PreferredSize(
            //   preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            //   // child: CustomAppBar(rating: agrs.product.rating!),
            // ),
            appBar: AppBar(),
            body: Body(product: productModel),
          );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
