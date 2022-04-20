import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/models/Orders.dart';
import 'package:personalshopper/size_config.dart';

DateFormat dateFormat = DateFormat('dd-MM-yyyy');

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(14), vertical: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderList[index].id,
                      style: const TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                        'Order date: ${dateFormat.format(orderList[index].orderDate)}'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Order Status'),
                        Text(orderList[index].status),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Items'),
                        Text(
                            '${orderList[index].num_item_ordered} items purchased'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price'),
                        Text(
                          'RM${orderList[index].total.toStringAsFixed(2)}',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ],
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
}

class OrderList {}
