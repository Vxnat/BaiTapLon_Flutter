import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/modules/order.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final foodModel = ProviderFood();
  final successNoti = const SnackBar(
    content: Text('Add To Cart Success'),
    duration: Duration(milliseconds: 800),
  );
  void orderAgain(String idOrder) {
    foodModel.orderAgain(idOrder);
    ScaffoldMessenger.of(context).showSnackBar(successNoti);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            hoverColor: Colors.white,
            highlightColor: const Color.fromARGB(255, 255, 208, 137),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.orange,
            )),
        title: const Text(
          'Order History',
          style: TextStyle(
              color: Color.fromARGB(255, 235, 141, 0),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: StreamBuilder(
            stream: APIs.getAllSeftOrders(),
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
                            ?.map((e) => OrderProducts.fromJson(e.data()))
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
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: const Text(
                                'No Information Was Found',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            const Text(
                              'Let\'s shopping now',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    }
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                            255, 197, 197, 197)
                                        .withOpacity(
                                            0.5), // Màu của boxShadow và độ trong suốt
                                    spreadRadius:
                                        5, // Bán kính mở rộng của boxShadow
                                    blurRadius: 7, // Bán kính mờ của boxShadow
                                    offset: const Offset(0,
                                        3), // Độ dịch chuyển của boxShadow theo trục x và y
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                          text: TextSpan(children: [
                                        const TextSpan(
                                            text: 'Food',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        TextSpan(
                                          text: item.id,
                                        ),
                                      ])),
                                      Text(
                                        item.date,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 250,
                                            height: 130,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: item.listCarts.length,
                                              itemBuilder: (context, index) {
                                                final itemCart =
                                                    item.listCarts[index];
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        itemCart
                                                            .product.imgProduct,
                                                        height: 80,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        width: 90,
                                                        child: Text(
                                                          '${itemCart.product.name} x${itemCart.quantity}',
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                '\$ ${item.totalPrice.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                '${item.listCarts.length.toString()} Foods',
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                  const Divider(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(5),
                                              backgroundColor: Colors.orange,
                                              minimumSize: const Size(80, 40),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          onPressed: () {
                                            orderAgain(item.id);
                                          },
                                          child: const Text(
                                            'Order Again',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ));
                  }
              }
              return Container();
            },
          )),
    );
  }
}

// if (providerFood.listOders.isEmpty) {

//             }
            