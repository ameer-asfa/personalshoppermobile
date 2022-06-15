// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/screens/store/store_screen.dart';
import 'package:personalshopper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personalshopper/apiConstant.dart';
import '../../../constants.dart';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key? key}) : super(key: key);
  static String routeName = '/add_product';
  final String nodeEndPoint = '${apiConstant.restApiUrl}/image';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? name;
  String? price;
  String? description;
  String? category;
  String? shopperId;

  XFile? imageFile;
  Dio dio = new Dio();

  void _getShopperId() async {
    var prefs = await SharedPreferences.getInstance();
    shopperId = prefs.getString('id');
    setState(() {
      shopperId = shopperId;
    });
  }

  @override
  void initState() {
    _getShopperId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _chooseImage();
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: imageFile == null
                            ? Container(
                                width: double.infinity,
                                height: 300,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/no_image_icon.jpg'),
                                      fit: BoxFit.contain),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Image.file(
                                  File(imageFile!.path),
                                  fit: BoxFit.contain,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _nameField(),
                const SizedBox(height: 30),
                _descriptionField(),
                const SizedBox(height: 30),
                _priceField(),
                const SizedBox(height: 30),
                _categoryDropDown(),
                const SizedBox(height: 30),
                DefaultButton(
                    text: "Add Product",
                    press: () {
                      _uploadImage();
                    }),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (newValue) => name = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter product name';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: "Product Name",
        hintText: "Product Name",
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  TextFormField _descriptionField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (newValue) => description = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter product description';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: "Product Description",
        hintText: "Product Description",
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  TextFormField _priceField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (newValue) => price = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter product price';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: "Product Price",
        hintText: "Product Price",
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  DropdownButtonFormField2<String> _categoryDropDown() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: const Text(
        'Product Category',
        style: TextStyle(fontSize: 16),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 40, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: [
        'Men\'s Fashion',
        'Women\'s Fashion',
        'Kid\'s Fashion',
        'Technology',
        'Furniture & Home Living'
      ]
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select product category';
        }
      },
      onChanged: (value) {
        //Do something when changing the item if you want.
      },
      onSaved: (value) {
        category = value.toString();
      },
    );
  }

  Widget _productImage() {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/no_image_icon.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _chooseImage() async {
    final ImagePicker _picker = ImagePicker();
    imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        imageFile = XFile(imageFile!.path);
      });
    }
  }

  _uploadImage() async {
    var formData = FormData.fromMap(
      {
        "name": name,
        "description": description,
        "category": "technology",
        "price": price,
        "shopper_id": shopperId,
        "image": await MultipartFile.fromFile(imageFile!.path),
      },
    );
    var response =
        await dio.post("${apiConstant.restApiUrl}/product/add", data: formData);

    if (response.statusCode == 200) {
      Navigator.pushNamedAndRemoveUntil(
          context, StoreScreen.routeName, (_) => false);
    } else {}
    debugPrint(imageFile!.path);
    debugPrint(response.toString());
  }
}
