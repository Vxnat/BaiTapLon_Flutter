// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/extensions/extension_time.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';
import 'package:flutter_application_e_commerce_app/screens/product_details_screen.dart';

class FilteredScreen extends StatefulWidget {
  String currentTextSearch;
  String idCategory;
  FilteredScreen({
    super.key,
    required this.currentTextSearch,
    required this.idCategory,
  });

  @override
  State<FilteredScreen> createState() => _FilteredScreenState();
}

class _FilteredScreenState extends State<FilteredScreen> {
  late TextEditingController searchController;
  final foodModel = ProviderFood();
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.currentTextSearch);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    hoverColor: Colors.white,
                    highlightColor: const Color.fromARGB(255, 255, 208, 137),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.orange,
                    )),
                Container(
                  width: MediaQuery.of(context).size.width - 55,
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
                      searchController.text = newValue;
                      widget.idCategory != '' ? widget.idCategory = '' : null;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: StreamBuilder(
                stream: APIs.getFilterData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      );
                    case ConnectionState.done:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final data = snapshot.data?.docs;
                        final list = data
                                ?.map((e) => Product.fromJson(e.data()))
                                .toList() ??
                            [];

                        // Khi Người Dùng Tìm Kiếm Bằng "Categories"
                        if (widget.idCategory != '') {
                          List<Product> newList = [];
                          for (var i in list) {
                            if (i.idCategory == widget.idCategory) {
                              newList.add(i);
                            }
                          }
                          if (newList.isEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.image_search,
                                    size: 70,
                                    color: Colors.orange,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 10),
                                    child: const Text(
                                      'No Foods Were Found',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  const Text(
                                    'Try Later',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            );
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 80,
                            child: GridView.builder(
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
                              itemCount: newList
                                  .length, // Số lượng phần tử thực tế trong danh sách
                              itemBuilder: (context, index) {
                                final item = newList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(item: item),
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
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
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
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
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text(
                                            item.nameBrand,
                                            style: const TextStyle(
                                                color: Colors.orange,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    ExtensionTime
                                                        .convertMinutesToTime(
                                                            item.cookingTime),
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5, bottom: 2),
                                                    child: Image.asset(
                                                      'img/fire-svgrepo-com.png',
                                                      width: 15,
                                                      height: 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text('\$${item.price.toString()}',
                                                  style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          // Khi Người Dùng Tìm Kiếm Bằng "KeyWords"
                          List<Product> newList = [];
                          for (var i in list) {
                            if (i.name.toLowerCase().contains(
                                searchController.text.toLowerCase())) {
                              newList.add(i);
                            }
                          }
                          if (newList.isEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.image_search,
                                    size: 70,
                                    color: Colors.orange,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 10),
                                    child: const Text(
                                      'No Foods Were Found',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  const Text(
                                    'Try Using More General Keywords',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            );
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 80,
                            child: GridView.builder(
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
                              itemCount: newList
                                  .length, // Số lượng phần tử thực tế trong danh sách
                              itemBuilder: (context, index) {
                                final item = newList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(item: item),
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
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
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
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
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text(
                                            item.nameBrand,
                                            style: const TextStyle(
                                                color: Colors.orange,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    ExtensionTime
                                                        .convertMinutesToTime(
                                                            item.cookingTime),
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5, bottom: 2),
                                                    child: Image.asset(
                                                      'img/fire-svgrepo-com.png',
                                                      width: 15,
                                                      height: 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text('\$${item.price.toString()}',
                                                  style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                  }
                  return Container();
                },
              ))
        ],
      ),
    );
  }
}
