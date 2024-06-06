import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/extensions/extension_time.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';
import 'package:flutter_application_e_commerce_app/screens/product_details_screen.dart';

class FavoriteProductScreen extends StatefulWidget {
  const FavoriteProductScreen({
    super.key,
  });

  @override
  State<FavoriteProductScreen> createState() => _FavoriteProductScreenState();
}

class _FavoriteProductScreenState extends State<FavoriteProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Product',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 115, 0),
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.orange,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: StreamBuilder(
                  stream: APIs.getAllFavorites(),
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
                          if (list.isEmpty) {
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
                                      'No Information Was Found',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  const Text(
                                    'Let\' Add Your New Favorite Food',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            );
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
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
                              itemCount: list
                                  .length, // Số lượng phần tử thực tế trong danh sách
                              itemBuilder: (context, index) {
                                final item = list[index];
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
                                            height: 130,
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
                    return Container();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
