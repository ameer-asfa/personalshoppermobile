import 'package:flutter/material.dart';
import 'package:personalshopper/components/cust_bottom_nav_bar.dart';
import 'package:personalshopper/components/shopper_bottom_nav_bar.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/enums.dart';
import 'package:personalshopper/screens/store/components/add_product_screen.dart';
import 'package:personalshopper/screens/store/components/body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  static String routeName = '/store';

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
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
      appBar: AppBar(),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, AddProductScreen.routeName),
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:
          const ShopperNavBar(selectedMenu: ShopperMenuState.store),
    );
  }
}
