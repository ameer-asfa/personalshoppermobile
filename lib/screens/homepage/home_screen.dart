import 'package:flutter/material.dart';
import 'package:personalshopper/components/cust_bottom_nav_bar.dart';
import 'package:personalshopper/components/shopper_bottom_nav_bar.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/screens/cart/cart_screen.dart';
import 'package:personalshopper/screens/homepage/components/body.dart';
import 'package:personalshopper/screens/homepage/components/header_button.dart';
import 'package:personalshopper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../enums.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PSMS",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          headerButton(
            iconSrc: Icons.notifications_outlined,
            numberOfItems: 0,
            press: () {},
          ),
          headerButton(
            iconSrc: Icons.shopping_cart_outlined,
            numberOfItems: 0,
            press: () => Navigator.pushNamed(context, CartScreen.routeName),
          ),
        ],
      ),
      body: Body(),
      bottomNavigationBar: (userRole == 'Customer')
          ? const CustomerNavBar(selectedMenu: CustomerMenuState.home)
          : const ShopperNavBar(selectedMenu: ShopperMenuState.home),
    );
  }
}
