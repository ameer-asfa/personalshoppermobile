// import 'package:flutter/material.dart';

// class CartScreen extends StatelessWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   static String routeName = "/cart";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           children: [
//             Text('Your Cart'),
//             Text(
//               '1 items',
//               style: Theme.of(context).textTheme.caption,
//             ),
//           ],
//         ),
//       ),
//       // body: Body(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:personalshopper/models/Cart.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Body(),
      bottomNavigationBar: CheckoutCard(),
    );
  }

  // AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     title: Column(
  //       children: [
  //         const Text(
  //           "Your Cart",
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         Text(
  //           "${demoCarts.length} items",
  //           style: Theme.of(context).textTheme.caption,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
