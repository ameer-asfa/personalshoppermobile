import 'package:flutter/widgets.dart';
import 'package:personalshopper/screens/cart/cart_screen.dart';
import 'package:personalshopper/screens/checkout/checkout_screen.dart';
import 'package:personalshopper/screens/homepage/home_screen.dart';
import 'package:personalshopper/screens/order/order_screen.dart';
import 'package:personalshopper/screens/order_details/order_details.dart';
import 'package:personalshopper/screens/payment/payment_screen.dart';
import 'package:personalshopper/screens/product_details/product_details_screen.dart';
import 'package:personalshopper/screens/profile/components/edit_profile.dart';
import 'package:personalshopper/screens/profile/profile_screen.dart';
import 'package:personalshopper/screens/sign_in/sign_in_screen.dart';
import 'package:personalshopper/screens/sign_up/sign_up_screen.dart';
import 'package:personalshopper/screens/store/components/add_product_screen.dart';
import 'package:personalshopper/screens/store/components/edit_product_screen.dart';
import 'package:personalshopper/screens/store/store_screen.dart';
import 'package:personalshopper/screens/success/success_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  OrderScreen.routeName: (context) => OrderScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
  EditProfileScreen.routeName: (context) => EditProfileScreen(),
  StoreScreen.routeName: (context) => StoreScreen(),
  AddProductScreen.routeName: (context) => AddProductScreen(),
  EditProductScreen.routeName: (context) => EditProductScreen(),
  CheckoutScreen.routeName: (context) => CheckoutScreen(),
  PaymentScreen.routeName: (context) => PaymentScreen(),
  SuccessScreen.routeName: (context) => SuccessScreen(),
  OrderDetailScreen.routeName: (context) => OrderDetailScreen(),
};
