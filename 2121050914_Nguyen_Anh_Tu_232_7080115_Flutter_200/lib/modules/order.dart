import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_e_commerce_app/modules/cart.dart';

class OrderProducts {
  late String id;
  late String date;
  late List<Cart> listCarts;
  late double totalPrice;

  OrderProducts({
    required this.id,
    required this.date,
    required this.listCarts,
    required this.totalPrice,
  });

  factory OrderProducts.fromDocument(QueryDocumentSnapshot doc) {
    List<dynamic> cartsJson = doc['list_carts'];
    List<Cart> cartsList = [];
    cartsList = cartsJson.map((cartJson) => Cart.fromJson(cartJson)).toList();
    return OrderProducts(
      listCarts: cartsList,
      id: doc['id'] ?? '',
      date: doc['date'] ?? '',
      totalPrice: doc['total_price'] ?? 0.00,
    );
  }

  OrderProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    totalPrice = json['total_price'];

    // Chuyển đổi danh sách list_carts từ JSON sang danh sách các đối tượng Cart
    if (json['list_carts'] != null) {
      var cartsJson = json['list_carts'] as List;
      listCarts = cartsJson.map((cartJson) => Cart.fromJson(cartJson)).toList();
    } else {
      listCarts =
          []; // Nếu không có dữ liệu list_carts, gán listCarts là danh sách rỗng
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['total_price'] = totalPrice;
    data['list_carts'] = listCarts.map((cart) => cart.toJson()).toList();
    return data;
  }
}
