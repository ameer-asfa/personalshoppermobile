import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personalshopper/components/product_card.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/screens/homepage/components/carousel_slider.dart';
import 'package:personalshopper/screens/product_details/product_details_screen.dart';
import 'package:personalshopper/size_config.dart';
import 'package:personalshopper/apiConstant.dart';
import 'package:personalshopper/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'search_field.dart';
import 'package:search_page/search_page.dart';

import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List<Product> productModel;
  bool isLoading = true;

  Future getProduct() async {
    final responseProduct = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/product/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    productModel = List<Product>.from(json
        .decode(responseProduct.body)
        .map((model) => Product.fromJson(model)));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  searchField(context),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  carouselSlider(imgList: imgList),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Column(
                    children: [
                      sectionTitle(
                        text: "Featured Product",
                        press: () {},
                      ),
                      SizedBox(height: getProportionateScreenWidth(20)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...List.generate(
                              productModel.length,
                              (index) => ProductCard(
                                  product: productModel[index],
                                  press: () async {
                                    var prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        'product_id', productModel[index].id!);
                                    Navigator.pushNamed(context,
                                        ProductDetailsScreen.routeName);
                                  }),
                            ),
                            SizedBox(width: getProportionateScreenWidth(20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Padding searchField(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.89,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchPage<Product>(
                    barTheme: ThemeData.light(),
                    onQueryUpdate: (value) => print(value),
                    items: productModel,
                    searchLabel: 'Search',
                    suggestion: const Center(
                      child: Text('Search for product by product name'),
                    ),
                    failure: const Center(
                      child: Text('No product found :('),
                    ),
                    filter: (productModel) => [
                      productModel.name,
                    ],
                    builder: (productModel) => ListTile(
                      onTap: () async {
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setString('product_id', productModel.id!);
                        Navigator.pushNamed(
                            context, ProductDetailsScreen.routeName);
                      },
                      leading: productModel.image == null
                          ? Image.asset('assets/images/no_image_icon.jpg')
                          : Image.network(
                              "${apiConstant.restApiUrl}/uploads/product_image/" +
                                  productModel.image!,
                              width: 100,
                              height: 100,
                            ),
                      title: Text(productModel.name!),
                      subtitle: Text(
                          'RM${productModel.price!.toStringAsFixed(2)}',
                          style: const TextStyle(color: kPrimaryColor)),
                    ),
                  ),
                );
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(10),
                    vertical: getProportionateScreenHeight(20)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Search Product Name",
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<String> imgList = [
    // 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    // 'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    // 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    // 'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    // 'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    // 'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    'https://100comments.com/wp-content/uploads/2019/07/%E2%80%98Win-the-Day-with-NIVEA-and-EUCERIN%E2%80%99-Campaign-Banner.jpg',
    'https://eatbook.sg/wp-content/uploads/2022/01/shopee-cny-promotional-banner.jpg',
    'https://live.staticflickr.com/1963/45041956024_4cc82d6e2c_z.jpg ',
  ];
}

class sectionTitle extends StatelessWidget {
  const sectionTitle({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: const Text(
              "See More",
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
