import 'package:flutter/material.dart';
import 'package:personalshopper/screens/homepage/home_screen.dart';
import 'package:personalshopper/screens/order/order_screen.dart';
import 'package:personalshopper/screens/profile/profile_screen.dart';
import 'package:personalshopper/screens/store/store_screen.dart';
import '../constants.dart';
import '../enums.dart';

class ShopperNavBar extends StatelessWidget {
  const ShopperNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final ShopperMenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: ShopperMenuState.home == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, (_) => false),
                ),
                const Text('Home'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: ShopperMenuState.order == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, OrderScreen.routeName),
                ),
                const Text('Order'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.store_mall_directory_outlined,
                    color: ShopperMenuState.store == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, StoreScreen.routeName),
                ),
                const Text('Store'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.person_outline,
                    color: ShopperMenuState.profile == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, ProfileScreen.routeName),
                ),
                const Text('Profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
