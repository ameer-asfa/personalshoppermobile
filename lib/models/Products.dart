import 'package:flutter/material.dart';

class Product {
  String? id;
  String? name;
  String? description;
  String? category;
  num? price;
  int? num_sold;
  String? image;
  String? shopperId;
  double? rating;

  Product(
      {this.id,
      this.name,
      this.description,
      this.category,
      this.price,
      this.num_sold,
      this.image,
      this.shopperId,
      this.rating});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    price = json['price'];
    num_sold = json['num_sold'];
    image = json['image'];
    shopperId = json['shopper_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category'] = this.category;
    data['price'] = this.price;
    data['num_sold'] = this.num_sold;
    data['image'] = this.image;
    data['shopper_id'] = this.shopperId;
    return data;
  }
}

// Demo Product

const String description =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer scelerisque non lacus id elementum. Sed vel tempor nisl. Suspendisse potenti.';

List<Product> demoProduct = [
  Product(
    id: '1',
    name: 'PS4 Controller - White Edition',
    num_sold: 10,
    description: description,
    category: 'Entertainment',
    image: null,
    price: 80.00,
    rating: 4.5,
  ),
  Product(
    id: '2',
    num_sold: 2,
    name: 'Nike Sport White - Man Pant',
    description: description,
    category: 'Clothes',
    image: null,
    price: 100.00,
    rating: 4.5,
  ),
  Product(
    id: '3',
    num_sold: 5,
    name: 'Decathlon Helmet - Red and Yellow',
    description: description,
    category: 'Sports',
    image: null,
    price: 90.00,
    rating: 5.0,
  ),
  Product(
    id: '4',
    num_sold: 7,
    name: 'Bike Glove - Blue and White',
    description: description,
    category: 'Sports',
    image: null,
    price: 40.00,
    rating: 4.1,
  ),
];
