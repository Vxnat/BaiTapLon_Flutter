import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';

class Cart {
  late Product product;
  late int quantity;
  Cart({
    required this.product,
    required this.quantity,
  });

  factory Cart.fromDocument(QueryDocumentSnapshot doc) {
    return Cart(
        product: Product.fromJson(doc['product']),
        quantity: doc['quantity'] ?? 0);
  }

  Cart.fromJson(Map<String, dynamic> json) {
    product = Product.fromJson(json['product']);
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product'] = product.toMap();
    data['quantity'] = quantity;
    return data;
  }
}
