import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/size_config.dart';
import 'package:personalshopper/apiConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final Product product;

  const Body({Key? key, required this.product}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // ProductImages(product: widget.product),
        checkImage(),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: TopRoundedContainer(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: getProportionateScreenWidth(20),
                            right: getProportionateScreenWidth(20),
                            bottom: getProportionateScreenWidth(40),
                            top: getProportionateScreenWidth(50),
                          ),
                          child: DefaultButton(
                            text: "Add To Cart",
                            press: () {
                              _checkForShopper();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Checking if image exist
  checkImage() {
    if (widget.product.image == null) {
      return SizedBox(
        width: getProportionateScreenWidth(238),
        child: AspectRatio(
          aspectRatio: 1,
          child: Hero(
            tag: widget.product.id.toString(),
            child: Image.asset('assets/images/no_image_icon.jpg'),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: getProportionateScreenWidth(238),
        child: AspectRatio(
          aspectRatio: 1,
          child: Hero(
              tag: widget.product.id.toString(),
              child: Image.network(
                  "${apiConstant.restApiUrl}/uploads/product_image/" +
                      widget.product.image!)),
        ),
      );
    }
  }

  // This is to ensure customer can only add item from one shopper at a time
  _checkForShopper() async {
    String? shopperId;
    var prefs = await SharedPreferences.getInstance();
    var productId = prefs.getString('product_id');
    var customerId = prefs.getString('id');

    final responseShopper = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/product/' + productId!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));

    final responseCart = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/cart/get/' + customerId!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));

    var parseShopper = json.decode(responseShopper.body);
    var parseCart = json.decode(responseCart.body);

    shopperId = parseShopper[0]['shopper_id'];

    if (parseCart.length > 0) {
      if (parseCart[0]['shopper_id'] == parseShopper[0]['shopper_id']) {
        _addToCart();
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Add to Cart Error"),
            content: const Text(
                "You can only add products from one shopper at a time"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Okay"),
              ),
            ],
          ),
        );
      }
    } else {
      _addToCart();
    }
  }

  _addToCart() async {
    var prefs = await SharedPreferences.getInstance();
    var customerId = prefs.getString('id');
    var productId = prefs.getString('product_id');
    var price = widget.product.price;

    final response = await http
        .post(Uri.parse('${apiConstant.restApiUrl}/cart/add'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(<String, String>{
              'customerId': customerId!,
              'productId': productId!,
              'price': price.toString()
            }))
        .timeout(const Duration(seconds: 3));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item Added To Cart'),
          duration: Duration(milliseconds: 1500),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add item to cart'),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }
}
