import 'package:flutter/material.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/apiConstant.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/screens/store/components/add_product_screen.dart';
import 'package:personalshopper/screens/store/components/edit_product_screen.dart';
import 'package:personalshopper/screens/store/store_screen.dart';
import 'package:personalshopper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

enum Menu { edit, delete }

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRation = 1.02,
    required this.product,
    required this.press,
  }) : super(key: key);

  final double width, aspectRation;
  final Product product;
  final GestureTapCallback press;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String? userRole;
  String _selectedMenu = '';

  _getUserRole() async {
    var prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('user_role');
    setState(() {
      userRole = userRole;
    });
  }

  @override
  void initState() {
    _getUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: widget.press,
        child: SizedBox(
          width: getProportionateScreenWidth(widget.width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: widget.aspectRation,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: widget.product.image != null
                      ? Image.network(
                          "${apiConstant.restApiUrl}/uploads/product_image/" +
                              widget.product.image!)
                      : Image.asset('assets/images/no_image_icon.jpg'),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.product.name!,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RM${widget.product.price}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  //
                  userRole != 'Customer'
                      ? PopupMenuButton(
                          // Callback that sets the selected popup menu item.
                          onSelected: (Menu item) async {
                            var prefs = await SharedPreferences.getInstance();
                            if (item.name == 'edit') {
                              prefs.setString('product_id', widget.product.id!);
                              Navigator.pushNamed(
                                  context, EditProductScreen.routeName);
                            } else if (item.name == 'delete') {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Delete Confirmation"),
                                  content: const Text(
                                      "Are you sure you want to delete this product?"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final response = await http.delete(
                                            Uri.parse(
                                                '${apiConstant.restApiUrl}/product/delete/' +
                                                    widget.product.id!),
                                            headers: <String, String>{
                                              'Content-Type':
                                                  'application/json; charset=UTF-8'
                                            }).timeout(
                                            const Duration(seconds: 3));
                                        Navigator.pushNamed(
                                            context, StoreScreen.routeName);
                                      },
                                      child: const Text("Okay"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<Menu>>[
                                const PopupMenuItem<Menu>(
                                  value: Menu.edit,
                                  child: Text('Edit Product'),
                                ),
                                const PopupMenuItem<Menu>(
                                  value: Menu.delete,
                                  child: Text('Delete Product'),
                                ),
                              ])
                      : SizedBox()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
