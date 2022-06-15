import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personalshopper/models/CartProduct.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/apiConstant.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

import 'package:http/http.dart' as http;

class CartCard extends StatefulWidget {
  const CartCard({Key? key, required this.cart}) : super(key: key);

  final Product cart;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: widget.cart.image == null
                    ? Image.asset('assets/images/no_image_icon.jpg')
                    : Image.network(
                        "${apiConstant.restApiUrl}/uploads/product_image/" +
                            widget.cart.image!)),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cart.name!,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "RM${widget.cart.price!}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                    fontSize: 18),
                // children: [
                //   TextSpan(
                //       text: " x${widget.cart.numOfItem}",
                //       style: Theme.of(context).textTheme.bodyText1),
                // ],
              ),
            )
          ],
        )
      ],
    );
  }
}
