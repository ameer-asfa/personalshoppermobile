class Orders {
  final int num_item_ordered;
  final DateTime orderDate;
  final String status, id;
  final double total;

  Orders(
      {required this.id,
      required this.num_item_ordered,
      required this.orderDate,
      required this.status,
      required this.total});
}

List<Orders> orderList = [
  Orders(
      id: 'ABCD1234',
      num_item_ordered: 2,
      orderDate: DateTime.now(),
      status: 'Shipping',
      total: 100.00),
  Orders(
      id: 'BCDE1234',
      num_item_ordered: 1,
      orderDate: DateTime.now(),
      status: 'Shipped',
      total: 120.00),
  Orders(
      id: 'DEF12345',
      num_item_ordered: 3,
      orderDate: DateTime.now(),
      status: 'Received',
      total: 120.00),
];
