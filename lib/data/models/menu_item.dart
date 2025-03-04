import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final int price;
  final Color color;

  MenuItem(this.name, this.price, this.color);

  @override
  String toString() {
    return 'MenuItem{name: $name, price: $price, color: $color}';
  }
}
