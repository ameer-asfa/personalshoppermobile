import 'package:flutter/widgets.dart';
import 'package:personalshopper/screens/sign_in/sign_in_screen.dart';
import 'package:personalshopper/screens/sign_up/sign_up_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
};
