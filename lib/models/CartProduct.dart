class CartProduct {
  String? id;
  num? price;
  String? status;
  String? cartId;
  String? productId;

  CartProduct({this.id, this.price, this.status, this.cartId, this.productId});

  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    status = json['status'];
    cartId = json['cartId'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['status'] = this.status;
    data['cartId'] = this.cartId;
    data['productId'] = this.productId;
    return data;
  }
}
