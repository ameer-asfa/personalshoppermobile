import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/screens/checkout/checkout_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:personalshopper/apiConstant.dart';

import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../../size_config.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  late List<Product> cartModel;
  bool isLoading = true;
  double total = 0.00;
  int index = 0;

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

    var parse = await json.decode(response.body);
    cartModel =
        List<Product>.from(parse.map((model) => Product.fromJson(model)));

    while (index < cartModel.length) {
      total += cartModel[index].price!;
      index++;
    }

    setState(() {
      total = total;
    });
  }

  @override
  void initState() {
    getCustomerId().then((id) => getProductInCart(id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    style: const TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: "RM${total.toString()}",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () async {
                      var prefs = await SharedPreferences.getInstance();
                      prefs.setDouble('total', total);
                      Navigator.pushNamed(context, CheckoutScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
