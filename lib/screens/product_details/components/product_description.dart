import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/models/Shopper.dart';

import 'package:http/http.dart' as http;
import 'package:personalshopper/apiConstant.dart';
import 'package:personalshopper/screens/store/store_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  late Shopper shopperModel;
  String? shopperName;
  bool isLoading = true;

  _getShopperName() async {
    final response = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/profile/shopper/' +
            widget.product.shopperId!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));
    var parse = json.decode(response.body);
    print(parse);
    setState(() {
      shopperName = parse['name'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getShopperName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Text(
                  widget.product.name!,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'BY ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                          text: shopperName!,
                          style: TextStyle(color: kPrimaryColor, fontSize: 16),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              var prefs = await SharedPreferences.getInstance();
                              var userRole = prefs.getString('user_role');
                              if (userRole == 'Customer') {
                                prefs.setString(
                                    'shopper_id', widget.product.shopperId!);
                                Navigator.pushNamed(
                                    context, StoreScreen.routeName);
                              }
                            }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Text(
                  "RM${widget.product.price}",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(20),
                  right: getProportionateScreenWidth(64),
                ),
                child: Text(
                  widget.product.description!,
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: 10,
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Text(
                        "See More Detail",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: kPrimaryColor),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
