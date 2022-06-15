import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/models/Orders.dart';
import 'package:personalshopper/screens/order_details/order_details.dart';
import 'package:personalshopper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personalshopper/apiConstant.dart';
import 'package:personalshopper/models/Orders.dart';

import 'package:http/http.dart' as http;

DateFormat dateFormat = DateFormat('dd-MM-yyyy');

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List<Order> orderList;
  bool isLoading = true;
  String? role;
  String? id;

  _getCartId() async {
    var prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    role = prefs.getString('user_role');
    print(role);

    final response = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/cart/getId/' + id!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));

    setState(() {
      role = role;
    });
    return response.body;
  }

  _getOrder(cartId) async {
    if (role == 'Customer') {
      final response = await http.get(
          Uri.parse('${apiConstant.restApiUrl}/order/get/customer/' + cartId!),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }).timeout(const Duration(seconds: 3));
      var parse = await json.decode(response.body);
      orderList = List<Order>.from(parse.map((model) => Order.fromJson(model)));
    } else {
      final response = await http.get(
          Uri.parse('${apiConstant.restApiUrl}/order/get/shopper/' + id!),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }).timeout(const Duration(seconds: 3));
      var parse = await json.decode(response.body);
      orderList = List<Order>.from(parse.map((model) => Order.fromJson(model)));
    }

    Future.delayed(Duration.zero, () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCartId().then((id) => _getOrder(id));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(14), vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      // side: BorderSide(
                      //   color: Colors.grey.withOpacity(0.1),
                      //   width: 1,
                      // ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: InkWell(
                        onTap: () async {
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setString('order_id', orderList[index].id!);
                          Navigator.pushNamed(
                              context, OrderDetailScreen.routeName);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderList[index].id!,
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text('Order date: ${orderList[index].orderDate!}'),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Order Status'),
                                Text(orderList[index].status!),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Items'),
                                Text(
                                    '${orderList[index].quantity} items purchased'),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Price'),
                                Text(
                                  'RM${orderList[index].total!.toStringAsFixed(2)}',
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
