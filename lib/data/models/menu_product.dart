import 'package:flutter/material.dart';

class MenuProduct {
  final String name;
  final int price;
  final Color color;

  MenuProduct(this.name, this.price, this.color);

  @override
  String toString() {
    return 'MenuProduct{name: $name, price: $price, color: $color}';
  }
}
