import 'package:flutter/material.dart';
import 'package:personalshopper/components/cust_bottom_nav_bar.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/enums.dart';
import 'package:personalshopper/screens/order/components/body.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static String routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Body(),
      bottomNavigationBar: const CustomerNavBar(selectedMenu: MenuState.order),
    );
  }
}
