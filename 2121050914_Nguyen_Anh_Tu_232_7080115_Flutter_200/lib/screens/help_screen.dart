import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
          'Help Center',
          style: TextStyle(
              color: Color.fromARGB(255, 235, 141, 0),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu hỏi thường gặp',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 1,
                color: Color.fromARGB(255, 158, 158, 158),
              ),
            ),
            Text(
              'Tôi muốn thay đổi đơn hàng',
              style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Làm thế nào khi Tài xế nhấn "hoàn tất đơn hàng" nhưng không giao hàng cho tôi',
                style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
              ),
            ),
            Text(
              'Tôi muốn đánh giá thái độ tài xế',
              style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Khi nào tôi nhận được tiền hoàn trả',
                style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
              ),
            ),
            Text(
              'Hướng dẫn mua hàng',
              style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
            )
          ],
        ),
      ),
    );
  }
}
