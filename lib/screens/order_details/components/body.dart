import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/models/Orders.dart';
import 'package:personalshopper/models/Products.dart';
import 'package:personalshopper/screens/order/order_screen.dart';
import 'package:personalshopper/screens/order_details/order_details.dart';
import 'package:personalshopper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personalshopper/apiConstant.dart';

import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = true;
  var role;
  String? orderId, shipping_courier, tracking_number;
  late Order orderModel;
  late List<Product> productModel;
  late String customerAddress;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _getOrderId() async {
    var prefs = await SharedPreferences.getInstance();
    role = prefs.getString('user_role');
    orderId = prefs.getString('order_id');
    return orderId;
  }

  _getOrderInfo(id) async {
    final responseOrder = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/order/getOrder/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    final responseProduct = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/order/getProduct/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    final responseCustomer = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/order/getCustomer/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    var parseOrder = await json.decode(responseOrder.body);
    var parseProduct = await json.decode(responseProduct.body);
    customerAddress = responseCustomer.body;

    orderModel = Order.fromJson(parseOrder);
    productModel = List<Product>.from(
        parseProduct.map((model) => Product.fromJson(model)));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getOrderId().then((id) => _getOrderInfo(id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  topTitle('Product'),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: productModel.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(productModel[index].name!),
                                subtitle: Text(
                                  'RM${productModel[index].price}',
                                  style: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 44,
                                    minHeight: 44,
                                    maxWidth: 64,
                                    maxHeight: 64,
                                  ),
                                  child: productModel[index].image != null
                                      ? Image.network(
                                          "${apiConstant.restApiUrl}/uploads/product_image/" +
                                              productModel[index].image!)
                                      : Image.asset(
                                          'assets/images/no_image_icon.jpg'),
                                ),
                              ),
                              const Divider(thickness: 1),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(height: 20),
                  topTitle('Shipping Details'),
                  const SizedBox(height: 20),
                  // Shipping Details
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        billingValue('Shipping Date',
                            orderModel.shipping_date ?? 'Not Shipped'),
                        const SizedBox(height: 10),
                        billingValue('Courier',
                            orderModel.shipping_courier ?? 'Not Shipped'),
                        const SizedBox(height: 10),
                        billingValue('Tracking Number',
                            orderModel.tracking_number ?? 'Not Shipped'),
                        const SizedBox(height: 10),
                        billingValue('Address', customerAddress),
                        // billingValue('Address', customerAddress),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  topTitle('Payment Details'),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        billingValue('Product Subtotal',
                            'RM${orderModel.total!.toStringAsFixed(2)}'),
                        const SizedBox(height: 10),
                        billingValue('Delivery Fee', 'RM15.00'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total\t:',
                                style: TextStyle(fontSize: 16)),
                            Text(
                              'RM${(orderModel.total! + 15).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: kPrimaryColor),
                              maxLines: 3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  role == 'Customer'
                      ? DefaultButton(
                          text: 'Order Received',
                          press: () => {_updateCompletedOrder()},
                        )
                      : DefaultButton(
                          text: 'Update Tracking',
                          press: () => {updateTrackingBottomSheet(context)})
                ],
              ),
            ),
          );
  }

  Text topTitle(title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Row billingValue(title, value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$title\t:', style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          maxLines: 3,
        ),
      ],
    );
  }

  Future<void> updateTrackingBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Text(
                      "Update Tracking Info",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    courierField(),
                    const SizedBox(height: 20),
                    trackingNumberField(),
                    const SizedBox(height: 20),
                    DefaultButton(
                      text: "Update Tracking",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _updateTracking(shipping_courier, tracking_number);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TextFormField courierField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (newValue) => shipping_courier = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter courier name';
        }
        return null;
      },
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(kPassNullError);
      //   } else if (value.length >= 8) {
      //     removeError(kShortPassError);
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(kPassNullError);
      //     return "";
      //   } else if (value.length < 8) {
      //     addError(kShortPassError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Courier Name",
        hintText: "Courier Name",

        //floatingLabelBehavior: FloatingLabelBehavior.auto,
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

  TextFormField trackingNumberField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (newValue) => tracking_number = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter tracking number';
        }
        return null;
      },
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(kPassNullError);
      //   } else if (value.length >= 8) {
      //     removeError(kShortPassError);
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(kPassNullError);
      //     return "";
      //   } else if (value.length < 8) {
      //     addError(kShortPassError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Tracking Number",
        hintText: "Tracking Number",

        //floatingLabelBehavior: FloatingLabelBehavior.auto,
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

  _updateTracking(shipping_courier, tracking_number) async {
    final prefs = await SharedPreferences.getInstance();
    var orderId = prefs.getString('order_id')!;
    DateTime now = DateTime.now();
    DateTime shipping_date = DateTime(now.year, now.month, now.day);

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('PATCH',
        Uri.parse('${apiConstant.restApiUrl}/order/update/' + orderId));
    request.body = json.encode({
      "shipping_courier": shipping_courier,
      "tracking_number": tracking_number,
      "shipping_date": shipping_date.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.pushNamed(context, OrderDetailScreen.routeName);
    }
  }

  _updateCompletedOrder() async {
    final prefs = await SharedPreferences.getInstance();
    var orderId = prefs.getString('order_id')!;

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('PATCH',
        Uri.parse('${apiConstant.restApiUrl}/order/update/order/' + orderId));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.pushNamed(context, OrderScreen.routeName);
    }
  }
}
