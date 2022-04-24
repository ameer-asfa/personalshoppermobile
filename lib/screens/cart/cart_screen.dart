import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static String routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Your Cart'),
            Text(
              '1 items',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      // body: Body(),
    );
  }
}
