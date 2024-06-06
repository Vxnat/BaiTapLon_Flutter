import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Product({
    required this.nameBrand,
    required this.idCategory,
    required this.price,
    required this.quantitySold,
    required this.description,
    required this.name,
    required this.imgProduct,
    required this.id,
    required this.cookingTime,
  });
  late final String nameBrand;
  late final String idCategory;
  late final double price;
  late final int quantitySold;
  late final String description;
  late final String name;
  late final String imgProduct;
  late final String id;
  late final int cookingTime;

  Map<String, dynamic> toMap() {
    return {
      'name_brand': nameBrand,
      'id_category': idCategory,
      'price': price,
      'quantity_sold': quantitySold,
      'description': description,
      'name': name,
      'img_product': imgProduct,
      'id': id,
      'cooking_time': cookingTime,
    };
  }

  factory Product.fromDocument(QueryDocumentSnapshot doc) {
    return Product(
        nameBrand: doc['name_brand'],
        idCategory: doc['id_category'] ?? 0,
        price: doc['price'] ?? 0,
        quantitySold: doc['quantity_sold'] ?? 0,
        description: doc['description'] ?? 0,
        name: doc['name'] ?? 0,
        imgProduct: doc['img_product'] ?? 0,
        id: doc['id'] ?? 0,
        cookingTime: doc['cooking_time'] ?? 0);
  }

  Product.fromJson(Map<String, dynamic> json) {
    nameBrand = json['name_brand'];
    idCategory = json['id_category'];
    price = json['price'];
    quantitySold = json['quantity_sold'];
    description = json['description'];
    name = json['name'];
    imgProduct = json['img_product'];
    id = json['id'];
    cookingTime = json['cooking_time'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name_brand'] = nameBrand;
    data['id_category'] = idCategory;
    data['price'] = price;
    data['quantity_sold'] = quantitySold;
    data['description'] = description;
    data['name'] = name;
    data['img_product'] = imgProduct;
    data['id'] = id;
    data['cooking_time'] = cookingTime;
    return data;
  }
}
