import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/auth/auth_gate.dart';
import 'package:flutter_application_e_commerce_app/components/side_bar_menu.dart';
import 'package:flutter_application_e_commerce_app/extensions/extension_time.dart';
import 'package:flutter_application_e_commerce_app/modules/cart.dart';
import 'package:flutter_application_e_commerce_app/modules/category.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';
import 'package:flutter_application_e_commerce_app/screens/best_sale_product_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/cart_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/filtered_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  final foodModel = ProviderFood();
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void filterData(String nameProduct, String idCategory, String kindOfSearch) {
    if (idCategory != '') {
      searchController.text = '';
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FilteredScreen(
        currentTextSearch: searchController.text,
        idCategory: idCategory,
      ),
    ));
  }

  void seeAllBestSaleProduct() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const BestSaleProductScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Row(
              children: [
                if (FirebaseAuth.instance.currentUser == null)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AuthGate(),
                      ));
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        'img/logo.png',
                      ),
                      radius: 25,
                    ),
                  ),
                if (FirebaseAuth.instance.currentUser == null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 45,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: searchController,
                    cursorColor: const Color.fromARGB(255, 77, 77, 77),
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        'img/search-svgrepo-com.png',
                        width: 10,
                        height: 10,
                      ),
                      hintText: 'Find your food',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 82, 82, 82),
                          fontStyle: FontStyle.italic,
                          fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 30.0),
                    ),
                    maxLines: 1,
                    onSubmitted: (newValue) {
                      filterData(searchController.text, '', 'searchBar');
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FirebaseAuth.instance.currentUser != null
                    ? StreamBuilder(
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
                                  margin: const EdgeInsets.only(left: 10),
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
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AuthGate(),
                          ));
                        },
                        child: Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              'img/shopping-basket-shopper-svgrepo-com.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ]),
                      ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: FirebaseAuth.instance.currentUser != null
          ? const SideBarMenu()
          : null,
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 247, 247, 247)),
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 1,
                  autoPlay: true,
                ),
                items: context
                    .read<ProviderFood>()
                    .listBanner
                    .map((item) => Container(
                          margin: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                width: 1000,
                                child: Image.asset(
                                  item.imgBanner,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'img/pizza.jpg',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                margin: const EdgeInsets.only(left: 13, top: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Categories',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.orange),
                ),
              ),
              StreamBuilder(
                stream: APIs.getAllCategories(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(child: SizedBox());
                    case ConnectionState.done:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final data = snapshot.data?.docs;
                        final list = data
                                ?.map((e) => Category.fromJson(e.data()))
                                .toList() ??
                            [];

                        return Container(
                          height: 80,
                          color: Colors.white,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final item = list[index];
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Chiều dọc sẽ co lại tối thiểu để vừa với nội dung
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Căn giữa theo chiều dọc
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        filterData(
                                            '', item.id, 'searchCategory');
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 60,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 240, 215),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              item.imgCategory,
                                              width: 30,
                                              height: 30,
                                            ),
                                            Text(
                                              item.name, // Nội dung của dòng chữ
                                              style: const TextStyle(
                                                  fontSize: 12.0, // Cỡ chữ
                                                  color: Color.fromARGB(
                                                      255, 53, 53, 53),
                                                  fontWeight:
                                                      FontWeight.bold // Màu chữ
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            8.0), // Khoảng cách giữa biểu tượng và dòng chữ
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Container();
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Best Sale Product',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: seeAllBestSaleProduct,
                      child: const Text(
                        'See More',
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: const Color.fromARGB(255, 240, 240, 240),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: StreamBuilder(
                      stream: APIs.getAllProducts(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.orangeAccent,
                            ));
                          case ConnectionState.done:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final data = snapshot.data?.docs;
                              final list = data
                                      ?.map((e) => Product.fromJson(e.data()))
                                      .toList() ??
                                  [];
                              int count = 0;
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Số lượng cột
                                  childAspectRatio:
                                      3 / 3, // Tỉ lệ khung hình của mỗi item
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: list
                                    .length, // ượng phần tử thực tế trong danh sách
                                itemBuilder: (context, index) {
                                  final item = list[index];
                                  if (count < 10) {
                                    if (item.quantitySold >= 10) {
                                      count++;
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                                    item: item),
                                          ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.5), // Màu của boxShadow và độ trong suốt
                                                spreadRadius:
                                                    5, // Bán kính mở rộng của boxShadow
                                                blurRadius:
                                                    7, // Bán kính mờ của boxShadow
                                                offset: const Offset(0,
                                                    3), // Độ dịch chuyển của boxShadow theo trục x và y
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(
                                                                10)),
                                                child: Image.asset(
                                                  item.imgProduct,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  fit: BoxFit.fill,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      'img/error-svgrepo-com.png',
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.13,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                                    child: Text(
                                                      item.nameBrand,
                                                      style: const TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 10),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      item.name,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              ExtensionTime
                                                                  .convertMinutesToTime(
                                                                      item.cookingTime),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 13),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5,
                                                                      bottom:
                                                                          2),
                                                              child:
                                                                  Image.asset(
                                                                'img/fire-svgrepo-com.png',
                                                                width: 15,
                                                                height: 15,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                            '\$${item.price.toString()}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }

                                  return null;
                                },
                              );
                            }
                        }
                        return Container();
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
