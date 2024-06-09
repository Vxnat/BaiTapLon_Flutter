import 'package:flutter/material.dart';

class AppInfor extends StatelessWidget {
  const AppInfor({super.key});
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
          'About VxnatFood',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'img/logo.png',
                    width: 70,
                    height: 70,
                  ),
                  RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: 'Vxnat',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 102, 0),
                            fontSize: 25)),
                    TextSpan(
                        text: 'Food',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 102, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 30))
                  ]))
                ],
              ),
            ),
            const Text(
              'VxnatFood là ứng dụng mua đồ ăn nhanh , cung cấp nhiều dịch vụ tiện ích bao gồm giao đồ ăn thức uống . Cho dù đó là vào buổi sáng, giữa ngày, buổi chiều hoặc buổi tối,VxnatFood có thể đáp ứng nhu cầu của bạn một cách nhanh chóng chỉ với một vài bước đơn giản.',
              style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text('Thông tin chủ sở hữu: Công ty Cổ phần Foody.',
                style: TextStyle(color: Color.fromARGB(255, 83, 83, 83))),
            const Text(
                'Giấy CN ĐKDN số: 0311828036 do Sở kế hoạch và Đầu tư Hà Nội cấp ngày 18/10/2003, sửa đổi lần thứ 21 , ngày 18/4/2024.',
                style: TextStyle(color: Color.fromARGB(255, 83, 83, 83))),
            const Text('Chịu trách nhiệm quản lý nội dung: Nguyễn Anh Tú',
                style: TextStyle(color: Color.fromARGB(255, 83, 83, 83))),
            const Text('Điện thoại liên hệ: 0399549912',
                style: TextStyle(color: Color.fromARGB(255, 83, 83, 83))),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Image.asset(
                    'img/placeholder-gps-svgrepo-com.png',
                    width: 15,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                      'Lầu G, tòa nhà Jabes 1, số 244 Cống Quỳnh,P.Phạm Ngũ Lão, TP.HCM',
                      style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)))
                ],
              ),
            ),
            Row(
              children: [
                Image.asset(
                  'img/email-mail-svgrepo-com.png',
                  width: 15,
                  height: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text('Nguyenatu2003@gmail.com',
                    style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
