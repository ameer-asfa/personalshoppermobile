import 'package:flutter/widgets.dart';
import 'package:personalshopper/screens/homepage/home_screen.dart';
import 'package:personalshopper/screens/order/order_screen.dart';
import 'package:personalshopper/screens/sign_in/sign_in_screen.dart';
import 'package:personalshopper/screens/sign_up/sign_up_screen.dart';
import 'package:personalshopper/screens/sign_up_personal_details/sign_up_personal_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignUpPersonalScreen.routeName: (context) => SignUpPersonalScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  OrderScreen.routeName: (context) => OrderScreen(),
};
