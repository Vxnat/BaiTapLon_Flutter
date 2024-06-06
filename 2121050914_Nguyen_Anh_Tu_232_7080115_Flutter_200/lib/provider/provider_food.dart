import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/extensions/extension_date.dart';
import 'package:flutter_application_e_commerce_app/modules/banner_slider.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';

class ProviderFood extends ChangeNotifier {
  // Tạo ra 1 instance duy nhất cho toàn bộ chương trình
  static final ProviderFood _instance = ProviderFood._();
  factory ProviderFood() => _instance;
  ProviderFood._();
  // Dùng ở home_screen cho slide
  List<BannerSlider> listBanner = [
    BannerSlider(id: '1', name: 'Pizza', imgBanner: 'img/pizza_banner.jpg'),
    BannerSlider(id: '2', name: 'Burger', imgBanner: 'img/burger_banner.jpg'),
    BannerSlider(
        id: '3', name: 'Fastfood', imgBanner: 'img/fastfood_banner.jpg')
  ];

  // Thêm sản phẩm vào Cart
  void addToCart(Product product, int quantity) {
    APIs.addToCart(product, quantity);
  }

  // Cập nhật số lượng của sản phẩm trong cart , tăng , giảm , 1 quantity
  void updateQuantity(String idProduct, int quantity, bool isIncrease) {
    APIs.updateQuantity(idProduct, quantity, isIncrease);
  }

  // Cập nhật số lượng của sản phẩm trong cart , TextField
  void updateQuantityByTextField(String idProduct, int newQuantity) {
    APIs.updateQuantityByTextField(idProduct, newQuantity);
  }

  // Xóa sản phẩm trong Cart
  void removeProductFromCart(String idProduct) {
    APIs.removeProductFromCart(idProduct);
    notifyListeners();
  }

  // Xác nhận Mã giảm giá
  void applyCoupon(String newCoupon) async {}

  // Cập nhật trạng thái sản phẩm yêu thích
  void updateFavoriteProduct(Product product) {
    APIs.updateFavoriteProduct(product);
  }

  // Xác nhận mua hàng , thêm vào danh sách mua hàng
  void addToOrder(double totalPrice) {
    APIs.addToOrder(generateRandomOrderID(),
        ExtensionDate.formatDateHomePage(DateTime.now()), totalPrice);
    // Xóa Cart ở trên API
    APIs.clearCart();
    // Làm rỗng dữ liệu Coupon
    notifyListeners();
  }

  // Đặt lại
  void orderAgain(String idOrder) async {
    APIs.orderAgain(idOrder.trim());
  }

  // Tạo Id bất kì cho orderItem
  String generateRandomOrderID() {
    final random = Random();
    String result = '#';
    for (int i = 0; i < 5; i++) {
      result += random.nextInt(10).toString();
    }
    result += '-';
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(10).toString();
    }
    return result;
  }
}
