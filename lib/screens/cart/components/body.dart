import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personalshopper/models/Cart.dart';
import 'package:personalshopper/models/CartProduct.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/screens/cart/components/cart_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personalshopper/apiConstant.dart';

import '../../../size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List<Product> cartModel;
  bool isLoading = true;

  Future<String> getCustomerId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? '';
  }

  Future getProductInCart(id) async {
    final response = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/cart/get/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    final responseId = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/cart/getId/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    var prefs = await SharedPreferences.getInstance();
    print(responseId.body);
    prefs.setString('cart_id', responseId.body);

    var parse = await json.decode(response.body);

    cartModel =
        List<Product>.from(parse.map((model) => Product.fromJson(model)));

    Future.delayed(Duration.zero, () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getCustomerId().then((id) => getProductInCart(id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: cartModel.length == 0
                ? SizedBox()
                : ListView.builder(
                    itemCount: cartModel.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Dismissible(
                        key: Key(cartModel[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            cartModel.removeAt(index);
                          });
                        },
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: const [
                              Spacer(),
                              Icon(Icons.delete),
                            ],
                          ),
                        ),
                        child: CartCard(cart: cartModel[index]),
                      ),
                    ),
                  ),
          );
  }
}
