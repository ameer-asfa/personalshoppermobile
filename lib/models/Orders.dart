// class Orders {
//   final int num_item_ordered;
//   final DateTime orderDate;
//   final String status, id;
//   final double total;

//   Orders(
//       {required this.id,
//       required this.num_item_ordered,
//       required this.orderDate,
//       required this.status,
//       required this.total});
// }

// List<Orders> orderList = [
//   Orders(
//       id: 'ABCD1234',
//       num_item_ordered: 2,
//       orderDate: DateTime.now(),
//       status: 'Shipping',
//       total: 100.00),
//   Orders(
//       id: 'BCDE1234',
//       num_item_ordered: 1,
//       orderDate: DateTime.now(),
//       status: 'Shipped',
//       total: 120.00),
//   Orders(
//       id: 'DEF12345',
//       num_item_ordered: 3,
//       orderDate: DateTime.now(),
//       status: 'Received',
//       total: 120.00),
// ];

class Order {
  String? id;
  String? orderDate;
  String? status;
  num? total;
  int? quantity;
  String? cartId;
  String? shopperId;
  String? shipping_date;
  String? shipping_courier;
  String? tracking_number;

  Order(
      {this.id,
      this.orderDate,
      this.status,
      this.total,
      this.quantity,
      this.cartId,
      this.shopperId,
      this.shipping_date,
      this.shipping_courier,
      this.tracking_number});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderDate = json['order_date'];
    status = json['status'];
    total = json['total'];
    quantity = json['quantity'];
    cartId = json['cartId'];
    shopperId = json['shopperId'];
    shipping_date = json['shipping_date'];
    shipping_courier = json['shipping_courier'];
    tracking_number = json['tracking_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_date'] = this.orderDate;
    data['status'] = this.status;
    data['total'] = this.total;
    data['quantity'] = this.quantity;
    data['cartId'] = this.cartId;
    data['shopperId'] = this.shopperId;
    return data;
  }
}
