import 'package:flutter/material.dart';

class CartModel {
  late final int? id;
  final String? productID;
  final String? productName;
  final int? initPrice;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;

  CartModel(
      {required this.id,
      required this.productID,
      required this.productName,
      required this.initPrice,
      required this.productPrice,
      required this.quantity,
      required this.unitTag,
      required this.image});

  CartModel.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        productID = res['productID'],
        productName = res['productName'],
        initPrice = res['initPrice'],
        productPrice = res['productPrice'],
        quantity = res['quantity'],
        unitTag = res['unitTag'],
        image = res['image'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productID': productID,
      'productName': productName,
      'initPrice': initPrice,
      'productPrice': productPrice,
      'quantity': quantity,
      'unitTag': unitTag,
      'image': image,
    };
  }
}
