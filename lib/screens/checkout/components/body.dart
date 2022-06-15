import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/models/Customer.dart';
import 'package:personalshopper/screens/payment/payment_screen.dart';
import 'package:personalshopper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personalshopper/apiConstant.dart';

import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Customer? customer;
  bool isLoading = true;
  double? total;

  Future<String?> getCustomerId() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getString('id');
  }

  getCustomerInfo(customerId) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/profile/customer/' + customerId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));
    var parse = json.decode(response.body);

    setState(() {
      total = prefs.getDouble('total');
      customer = Customer.fromJson(parse);
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCustomerId().then((customerId) => getCustomerInfo(customerId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                topTitle('Delivery Address'),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Text(
                      customer!.name! +
                          '\n' +
                          customer!.phone! +
                          '\n' +
                          customer!.address!,
                      style: const TextStyle(fontSize: 16, height: 1.8)),
                ),
                const SizedBox(height: 20),
                topTitle('Billing Information'),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      billingValue('Product Subtotal', 'RM${total!}'),
                      const SizedBox(height: 10),
                      billingValue('Delivery Fee', 'RM15.00'),
                      const SizedBox(height: 10),
                      billingValue('Total', 'RM${(total! + 15)}'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                DefaultButton(
                    text: 'Proceed to Payment',
                    press: () {
                      Navigator.pushNamed(context, PaymentScreen.routeName);
                    })
              ],
            ),
          );
  }

  Row billingValue(title, value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$title\t:', style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Text topTitle(title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
