import 'package:flutter/material.dart';
import 'package:personalshopper/components/cust_bottom_nav_bar.dart';
import 'package:personalshopper/components/shopper_bottom_nav_bar.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/enums.dart';
import 'package:personalshopper/screens/order_details/components/body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  static String routeName = '/order_details';

  @override
  State<OrderDetailScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderDetailScreen> {
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
          'Order Details',
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
