import 'package:flutter/material.dart';
import 'package:personalshopper/components/cust_bottom_nav_bar.dart';
import 'package:personalshopper/components/shopper_bottom_nav_bar.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/enums.dart';
import 'package:personalshopper/screens/order/components/body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static String routeName = '/order';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? userRole;

  getUserRoleSF() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role');
    });
  }

  @override
  void initState() {
    getUserRoleSF();
    super.initState();
  }

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
      bottomNavigationBar: (userRole == 'Customer')
          ? const CustomerNavBar(selectedMenu: CustomerMenuState.order)
          : const ShopperNavBar(selectedMenu: ShopperMenuState.order),
    );
  }
}
