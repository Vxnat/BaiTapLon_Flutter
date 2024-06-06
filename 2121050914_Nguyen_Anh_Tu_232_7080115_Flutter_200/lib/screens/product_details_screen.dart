import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/extensions/extension_time.dart';
import 'package:flutter_application_e_commerce_app/modules/cart.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';
import 'package:flutter_application_e_commerce_app/screens/cart_screen.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product item;
  const ProductDetailsScreen({super.key, required this.item});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Product item;
  late TextEditingController quantityController;
  late bool isFavorite;
  final foodModel = ProviderFood();
  // Đánh dấu vị trí của giỏ hàng bằng Global Key
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  // Đánh dấu vị trí của hình ảnh muốn tạo Animation
  GlobalKey widgetKey = GlobalKey();
  Function(GlobalKey)? runAddToCartAnimation;
  @override
  void initState() {
    super.initState();
    item = widget.item;
    quantityController = TextEditingController(text: '1');
  }

  void addToCartAnimationClick(GlobalKey widgetKey) async {
    if (runAddToCartAnimation != null) {
      await runAddToCartAnimation!(widgetKey);
    }
  }

  void addToCart(Product product, int quantity, GlobalKey widgetKey) {
    addToCartAnimationClick(widgetKey);
    foodModel.addToCart(product, quantity);
  }

  void updateFavoriteProduct() {
    isFavorite = !isFavorite;
    foodModel.updateFavoriteProduct(item);
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      // Gửi cho thư viện biết vị trí của giỏ hàng
      createAddToCartAnimation: (addToCart) {
        runAddToCartAnimation = addToCart;
      },
      dragAnimation: const DragToCartAnimationOptions(rotation: true),
      jumpAnimation: const JumpAnimationOptions(),
      height: 30,
      width: 30,
      cartKey: cartKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Image.asset(
                  item.imgProduct,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.orange,
                        size: 20,
                      )),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: AddToCartIcon(
                    badgeOptions: const BadgeOptions(active: false),
                    key: cartKey,
                    icon: StreamBuilder(
                      stream: APIs.getAllSeftCarts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data?.docs;
                          final list = data
                                  ?.map((e) => Cart.fromJson(e.data()))
                                  .toList() ??
                              [];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ));
                            },
                            child: Stack(children: [
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Image.asset(
                                  'img/shopping-basket-shopper-svgrepo-com.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              list.isNotEmpty
                                  ? Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          list.length.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ]),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ]),
              StreamBuilder(
                stream: APIs.getFavorite(widget.item.id),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                          ));
                    case ConnectionState.done:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final data = snapshot.data?.docs;
                        final list = data
                                ?.map((e) => Product.fromJson(e.data()))
                                .toList() ??
                            [];
                        list.isNotEmpty
                            ? isFavorite = true
                            : isFavorite = false;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hình ảnh muốn tạo Animation
                          Container(
                            key: widgetKey,
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.only(left: 15),
                            child: Image.asset(
                              item.imgProduct,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                updateFavoriteProduct();
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              )),
                        ],
                      );
                  }
                },
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 15, left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Text(
                          '\$${item.price.toString()}',
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<ProviderFood>(
                            builder: (context, value, child) {
                              return Text(
                                'Sold ${item.quantitySold.toString()}',
                              );
                            },
                          ),
                          Row(
                            children: [
                              Text(ExtensionTime.convertMinutesToTime(
                                  item.cookingTime)),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Image.asset(
                                  'img/fire-svgrepo-com.png',
                                  width: 25,
                                  height: 25,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        IconButton(
                          onPressed: () {
                            if (int.parse(quantityController.text) != 1) {
                              int newQuantity =
                                  int.parse(quantityController.text);
                              newQuantity--;
                              quantityController.text = newQuantity.toString();
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: 35,
                          height: 20,
                          child: TextField(
                            controller: quantityController,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.orange,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 255, 206, 132))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange)),
                              contentPadding: EdgeInsets.only(bottom: 18),
                            ),
                            onChanged: (value) {
                              if (int.parse(value) <= 0) {
                                int newQuantity = 1;
                                quantityController.text =
                                    newQuantity.toString();
                              } else {
                                int newQuantity = int.parse(value);
                                quantityController.text =
                                    newQuantity.toString();
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            int newQuantity =
                                int.parse(quantityController.text);
                            newQuantity++;
                            quantityController.text = newQuantity.toString();
                            setState(() {});
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text('Total Price'),
                              Text(
                                '\$${(item.price * int.parse(quantityController.text)).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                addToCart(
                                    item,
                                    int.parse(quantityController.text),
                                    widgetKey);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.shopping_cart_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Add To Cart',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
