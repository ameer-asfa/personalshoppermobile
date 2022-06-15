import 'package:flutter/material.dart';
import 'package:personalshopper/components/cust_bottom_nav_bar.dart';
import 'package:personalshopper/components/shopper_bottom_nav_bar.dart';
import 'package:personalshopper/enums.dart';
import 'package:personalshopper/screens/profile/components/body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static String routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: Text("Profile"),
      ),
      body: Body(),
      bottomNavigationBar: (userRole == 'Customer')
          ? const CustomerNavBar(selectedMenu: CustomerMenuState.profile)
          : const ShopperNavBar(selectedMenu: ShopperMenuState.profile),
    );
  }
}
