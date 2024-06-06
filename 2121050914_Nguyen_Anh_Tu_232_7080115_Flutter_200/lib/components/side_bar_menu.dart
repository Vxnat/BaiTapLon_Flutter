import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/components/info_card.dart';
import 'package:flutter_application_e_commerce_app/components/side_menu_title.dart';
import 'package:flutter_application_e_commerce_app/modules/menu_title.dart';
import 'package:flutter_application_e_commerce_app/screens/app_infor_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/favorite_product_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/help_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/order_history.dart';
import 'package:flutter_application_e_commerce_app/screens/profile_screen.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({super.key});

  @override
  State<SideBarMenu> createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> {
  List<MenuTitle> listMenuTitle = [
    MenuTitle(
        urlIcon: 'img/user_img.png',
        name: 'User',
        routeName: const ProfileScreen()),
    MenuTitle(
        urlIcon: 'img/favorite-favorite-svgrepo-com.png',
        name: 'Favorite',
        routeName: const FavoriteProductScreen()),
    MenuTitle(
        urlIcon: 'img/order-food-svgrepo-com.png',
        name: 'Order history',
        routeName: const OrderHistory()),
    MenuTitle(
        urlIcon: 'img/information-info-svgrepo-com.png',
        name: 'Information',
        routeName: const AppInfor()),
    MenuTitle(
        urlIcon: 'img/customer-service-help-svgrepo-com.png',
        name: 'Help',
        routeName: const HelpScreen()),
  ];
  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: const Color.fromARGB(255, 255, 145, 71),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );
  Widget buildHeader(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const InfoCard(name: 'VxnatFood', profession: 'FastFood'),
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
          child: Text(
            'Application'.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ]);
  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          for (var item in listMenuTitle)
            SideMenuTitle(
              item: item,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => item.routeName,
                    ));
              },
            ),
        ],
      );
}
