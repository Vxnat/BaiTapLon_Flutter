import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/extensions/extension_time.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';
import 'package:flutter_application_e_commerce_app/screens/product_details_screen.dart';

class BestSaleProductScreen extends StatefulWidget {
  const BestSaleProductScreen({super.key});

  @override
  State<BestSaleProductScreen> createState() => _BestSaleProductScreenState();
}

class _BestSaleProductScreenState extends State<BestSaleProductScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.orange,
            )),
        title: const Text(
          'Best Sale Product',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Số lượng cột
                            childAspectRatio:
                                3 / 3.3, // Tỉ lệ khung hình của mỗi item
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: list
                              .length, // ượng phần tử thực tế trong danh sách
                          itemBuilder: (context, index) {
                            final item = list[index];
                            if (item.quantitySold >= 10) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'img/error-svgrepo-com.png',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                              fit: BoxFit.cover,
                                            );
                                          },
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
                                                  margin: const EdgeInsets.only(
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return null;
                          },
                        );
                      }
                  }
                  return Container();
                },
              ))),
    );
  }
}
