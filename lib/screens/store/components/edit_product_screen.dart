import 'dart:async';
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

class EditProductScreen extends StatefulWidget {
  EditProductScreen({Key? key}) : super(key: key);
  static String routeName = '/edit_product';
  final String nodeEndPoint = '${apiConstant.restApiUrl}/image';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  String? name;
  String? price;
  String? description;
  String? category;
  String? image;
  String? shopperId;
  String? productId;
  late Product productModel;

  TextEditingController? _nameController;
  TextEditingController? _descriptionController;
  TextEditingController? _categoryController;
  TextEditingController? _priceController;

  XFile? imageFile;
  Dio dio = new Dio();

  Future<String> _getShopperAndProductId() async {
    var prefs = await SharedPreferences.getInstance();
    shopperId = prefs.getString('id');
    productId = prefs.getString('product_id');
    setState(() {
      shopperId = shopperId;
      productId = productId;
    });

    return productId ?? '';
  }

  void _getProductInfo(product_id) async {
    final response = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/product/' + product_id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));
    var parse = json.decode(response.body);
    print(parse[0]['image']);
    setState(() {
      productModel = Product.fromJson(parse[0]);
      _nameController = TextEditingController(text: parse[0]['name']);
      _priceController =
          TextEditingController(text: parse[0]['price'].toString());
      _descriptionController =
          TextEditingController(text: parse[0]['description']);
      _categoryController = TextEditingController(text: parse[0]['category']);
      name = parse[0]['name'];
      price = parse[0]['price'].toString();
      description = parse[0]['description'];
      category = parse[0]['category'];
      image = parse[0]['image'];
    });
  }

  @override
  void initState() {
    _getShopperAndProductId().then((product_id) => _getProductInfo(product_id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
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
                      _checkImages(),
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
                    text: "Update Product",
                    press: () {
                      _updateProduct();
                    }),
                const SizedBox(height: 30),
                _deleteButton(),
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
      controller: _nameController,
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
      controller: _descriptionController,
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
      controller: _priceController,
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
      hint: Text(
        category.toString(),
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

  _checkImages() {
    if (image == null && imageFile == null) {
      return Container(
        width: double.infinity,
        height: 300,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/no_image_icon.jpg'),
              fit: BoxFit.contain),
        ),
      );
    } else {
      if (imageFile != null) {
        return SizedBox(
            width: double.infinity,
            height: 300,
            child: Image.file(
              File(imageFile!.path),
              fit: BoxFit.contain,
            ));
      } else {
        return SizedBox(
            width: double.infinity,
            height: 300,
            child: Image.network(
                "${apiConstant.restApiUrl}/uploads/product_image/" + image!));
      }
    }
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

  _updateProduct() async {
    if (imageFile != null) {
      var formData = FormData.fromMap(
        {
          "name": name,
          "description": description,
          "category": category,
          "price": price,
          "image": await MultipartFile.fromFile(imageFile!.path),
        },
      );
      var response = await dio.patch(
          "${apiConstant.restApiUrl}/product/update/" + productId!,
          data: formData);
      if (response.statusCode == 200) {
        Navigator.pushNamedAndRemoveUntil(
            context, StoreScreen.routeName, (_) => false);
      }
    } else {
      var formData = FormData.fromMap(
        {
          "name": name,
          "description": description,
          "category": category,
          "price": price,
          "image": image,
        },
      );
      var response = await dio.patch(
          "${apiConstant.restApiUrl}/product/update/" + productId!,
          data: formData);
      if (response.statusCode == 200) {
        Navigator.pushNamedAndRemoveUntil(
            context, StoreScreen.routeName, (_) => false);
      }
    }
  }

  _deleteButton() {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: Colors.white,
          backgroundColor: Colors.red,
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Deleting Product'),
            content: const Text('Are you sure you want to remove product?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteProduct();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
        child: Text(
          "Delete Product",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _deleteProduct() async {
    var request = http.Request('DELETE',
        Uri.parse('${apiConstant.restApiUrl}/product/delete/' + productId!));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.pushNamed(context, StoreScreen.routeName);
    } else {
      print(response.reasonPhrase);
    }
  }
}
