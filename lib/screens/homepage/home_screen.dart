import 'package:flutter/material.dart';
import 'package:personalshopper/components/cust_bottom_nav_bar.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/screens/homepage/components/body.dart';
import 'package:personalshopper/screens/homepage/components/header_button.dart';
import 'package:personalshopper/size_config.dart';

import '../../enums.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/home';

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
            press: () {},
          ),
        ],
      ),
      body: Body(),
      bottomNavigationBar: const CustomerNavBar(selectedMenu: MenuState.home),
    );
  }
}
