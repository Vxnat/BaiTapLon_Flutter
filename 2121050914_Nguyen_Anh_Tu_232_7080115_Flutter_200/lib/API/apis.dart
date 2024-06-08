import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_e_commerce_app/modules/cart.dart';
import 'package:flutter_application_e_commerce_app/modules/order.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';
import 'package:flutter_application_e_commerce_app/modules/user_food.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static late UserFood me;

  // Dữ liệu cho profile_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .snapshots();
  }

  // Dữ liệu cho product_details_screen để load trái tim yêu thích
  static Stream<QuerySnapshot<Map<String, dynamic>>> getFavorite(String id) {
    return firestore
        .collection('favorites/${user.uid}/product/')
        .where('id', isEqualTo: id)
        .limit(1)
        .snapshots();
  }

  // Dữ liệu cho favorite_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFavorites() {
    return firestore.collection('favorites/${user.uid}/product').snapshots();
  }

  // Dữ liệu cho home_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() {
    return firestore.collection('products').snapshots();
  }

  // Dữ liệu cho home_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() {
    return firestore.collection('categories').snapshots();
  }

  // Dữ liệu cho filter_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getFilterData() {
    return firestore.collection('products').snapshots();
  }

  // Dữ liệu cho cart_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllSeftCarts() {
    return firestore.collection('carts/${user.uid}/products').snapshots();
  }

  // Dữ liệu cho order_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllSeftOrders() {
    return firestore.collection('orders/${user.uid}/products').snapshots();
  }

  // Dữ liệu cho listCarts trong Provider
  static Future<List<Cart>> getAllUserCarts() async {
    final cartRef =
        FirebaseFirestore.instance.collection('carts/${user.uid}/products');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef.get();

      List<Cart> carts = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();

        // Extract product and quantity data from the document
        Product product = Product.fromJson(data['product']);
        int quantity = data['quantity'];

        // Create a Cart object
        Cart cart = Cart(product: product, quantity: quantity);

        // Add to the list of carts
        carts.add(cart);
      }

      return carts;
    } catch (e) {
      rethrow;
    }
  }

  // Dữ liệu người dùng
  static Future<void> getSelfInfor() async {
    return await firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = UserFood.fromJson(user.data()!);
      }
    });
  }

  // Cập nhật sản phẩm yêu thích của người dùng
  static Future<void> updateFavoriteProduct(Product product) async {
    try {
      final favoriteRef = FirebaseFirestore.instance
          .collection('favorites/${user.uid}/product');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await favoriteRef.where('id', isEqualTo: product.id).limit(1).get();
      // Neu Product chua ton tai thi them moi
      if (querySnapshot.docs.isEmpty) {
        await favoriteRef.doc().set(product.toJson());
      } else {
        // Neu Product ton tai thi xoa khoi list
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        await favoriteRef.doc(doc.id).delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Thêm sản phẩm vào giỏ hàng người dùng
  static Future<void> addToCart(Product product, int quantity) async {
    try {
      final ref = firestore.collection('carts/${user.uid}/products');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await ref.where('product.id', isEqualTo: product.id).limit(1).get();
      // Nếu docs rỗng : Trong cart chưa có product nào giống với product chuẩn bị được thêm vào
      // Ta tiến thành thêm mới product
      if (querySnapshot.docs.isEmpty) {
        final Cart newProduct = Cart(product: product, quantity: quantity);
        ref.doc().set(newProduct.toJson());
      } else {
        // Nếu docs tồn tại : Trong carts đã chứa product chuẩn bị được thêm vào
        // Ta cập nhật quantity mới cho sản phẩm đó
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        // Lấy DocumentReference của tài liệu cần cập nhật
        DocumentReference docRef = ref.doc(doc.id);
        Cart cart = Cart.fromDocument(doc);
        if (cart.quantity + quantity > 100) {
          await docRef.update({'quantity': 100});
        } else {
          await docRef.update({'quantity': cart.quantity + quantity});
        }
      }
      // Thực hiện cập nhật trường 'quantity' của sản phẩm trong giỏ hàng
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Làm rỗng giỏ hàng
  static Future<void> clearCart() async {
    try {
      final cartRef = firestore.collection('carts/${user.uid}/products');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lặp qua danh sách các tài liệu trong giỏ hàng của người dùng hiện tại
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          // Xóa từng tài liệu (sản phẩm trong giỏ hàng)
          await doc.reference.delete();
        }
      } else {
        // Giỏ hàng của người dùng là trống
        throw Exception('User\'s cart is already empty.');
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Cập nhật số lượng tăng giảm cho sản phẩm trong giỏ hàng
  static Future<void> updateQuantity(
      String idProduct, int quantity, bool isIncrease) async {
    try {
      final cartRef = firestore.collection('carts/${user.uid}/products');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef
          .where('product.id', isEqualTo: idProduct)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        DocumentReference docRef = cartRef.doc(doc.id);

        // Thực hiện cập nhật trường 'quantity' của sản phẩm trong giỏ hàng
        if (isIncrease) {
          quantity < 100 ? await docRef.update({'quantity': ++quantity}) : null;
        } else {
          quantity--;
          quantity == 0
              ? await docRef.delete()
              : await docRef.update({'quantity': quantity});
        }
      } else {
        // Trường hợp không tìm thấy sản phẩm có idProduct trong giỏ hàng của người dùng
        throw Exception(
            'Product with ID $idProduct not found in the user\'s cart.');
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Cập nhật số lượng sản phầm qua TextField
  static Future<void> updateQuantityByTextField(
      String idProduct, int newQuantity) async {
    try {
      final cartRef = firestore.collection('carts/${user.uid}/products');
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef
          .where('product.id', isEqualTo: idProduct)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        await cartRef.doc(doc.id).update({'quantity': newQuantity});
      }
    } catch (e) {
      rethrow;
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  static Future<void> removeProductFromCart(String idProduct) async {
    try {
      final cartRef = firestore.collection('carts/${user.uid}/products');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef
          .where('product.id', isEqualTo: idProduct)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        // Lấy DocumentReference của tài liệu cần cập nhật
        DocumentReference docRef = cartRef.doc(doc.id);

        await docRef.delete();
      } else {
        // Trường hợp không tìm thấy sản phẩm có idProduct trong giỏ hàng của người dùng
        throw Exception(
            'Product with ID $idProduct not found in the user\'s cart.');
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Thêm listCart của người dùng vào danh sách mua hàng
  static Future<void> addToOrder(
      String id, String date, double totalPrice) async {
    final ordeRef = firestore.collection('orders/${user.uid}/products');
    final cartRef = firestore.collection('carts/${user.uid}/products');
    OrderProducts orderProducts;
    List<Cart> listCarts = [];
    QuerySnapshot<Map<String, dynamic>> cartQuerySnapshot = await cartRef.get();
    // Neu Carts khong rong , lay cac item trong cart them vao 1 listCart
    if (cartQuerySnapshot.docs.isNotEmpty) {
      for (var i in cartQuerySnapshot.docs) {
        Cart cartItem = Cart.fromDocument(i);
        listCarts.add(cartItem);
      }
    }
    // Them listCart vao orderHistory
    orderProducts = OrderProducts(
        id: id, date: date, listCarts: listCarts, totalPrice: totalPrice);
    await ordeRef.doc().set(orderProducts.toJson());
  }

  // Đặt lại sản phẩm tại trang order
  static Future<void> orderAgain(String idOrder) async {
    try {
      final orderRef = firestore.collection('orders/${user.uid}/products');
      final cartRef = firestore.collection('carts/${user.uid}/products');
      final productRef = firestore.collection('products');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await orderRef.where('id', isEqualTo: idOrder).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot<Map<String, dynamic>> doc =
            querySnapshot.docs.first;
        OrderProducts orderDocument = OrderProducts.fromDocument(doc);

        // Kiểm tra xem sản phầm người dùng "Đặt lại" có đang tồn tại bên trong
        // Cart của người dùng ko
        for (var cartItem in orderDocument.listCarts) {
          QuerySnapshot<Map<String, dynamic>> cartQuerySnapshot = await cartRef
              .where('product.id', isEqualTo: cartItem.product.id)
              .get();
          // Check if the product already exists in the cart
          if (cartQuerySnapshot.docs.isNotEmpty) {
            QueryDocumentSnapshot<Map<String, dynamic>> cartItemDoc =
                cartQuerySnapshot.docs.first;
            int currentQuantity = Cart.fromDocument(cartItemDoc).quantity;
            await cartRef.doc(cartItemDoc.id).update({
              'quantity': currentQuantity + cartItem.quantity,
            });
          } else {
            // Add a new cart item if it doesn't exist
            QuerySnapshot<Map<String, dynamic>> productQuerySnapshot =
                await productRef
                    .where('id', isEqualTo: cartItem.product.id)
                    .limit(1)
                    .get();
            if (productQuerySnapshot.docs.isNotEmpty) {
              await cartRef.doc().set(cartItem.toJson());
            }
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
