import 'package:flutter/material.dart';

import 'Products.dart';

class Cart {
  final Product product;
  final int numOfItem;

  Cart({required this.product, required this.numOfItem});
}

// Demo data for our cart

List<Cart> demoCarts = [
  Cart(product: demoProduct[0], numOfItem: 2),
  Cart(product: demoProduct[1], numOfItem: 1),
  Cart(product: demoProduct[3], numOfItem: 1),
];
