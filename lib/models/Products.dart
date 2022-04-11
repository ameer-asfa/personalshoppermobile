import 'package:flutter/material.dart';

class Product {
  final int id, num_sold;
  final String title, description, category;
  final List<String> images;
  final double rating, price;

  Product(
      {required this.id,
      this.num_sold = 0,
      required this.title,
      required this.description,
      required this.category,
      required this.images,
      this.rating = 0.0,
      required this.price});
}

// Demo Product

const String description =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer scelerisque non lacus id elementum. Sed vel tempor nisl. Suspendisse potenti.';

List<Product> demoProduct = [
  Product(
      id: 1,
      title: 'PS4 Controller',
      num_sold: 10,
      description: description,
      category: 'Entertainment',
      images: [
        "assets/images/ps4_console_white_1.png",
      ],
      price: 80.00),
  Product(
      id: 2,
      num_sold: 2,
      title: 'Nike Sport White - Man Pant',
      description: description,
      category: 'Clothes',
      images: [
        "assets/images/Image Popular Product 2.png",
      ],
      price: 100.00),
  Product(
      id: 3,
      num_sold: 5,
      title: 'Decathlon Helmet - Red and Yellow',
      description: description,
      category: 'Sports',
      images: [
        "assets/images/Image Popular Product 3.png",
      ],
      price: 90.00),
  Product(
      id: 4,
      num_sold: 7,
      title: 'Bike Glove - Blue and White',
      description: description,
      category: 'Sports',
      images: [
        "assets/images/glap.png",
      ],
      price: 40.00),
];
