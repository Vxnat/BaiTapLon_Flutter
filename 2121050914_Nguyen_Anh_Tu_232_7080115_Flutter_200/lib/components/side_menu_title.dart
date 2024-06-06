// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_application_e_commerce_app/modules/menu_title.dart';

class SideMenuTitle extends StatefulWidget {
  const SideMenuTitle({
    super.key,
    required this.item,
    required this.onTap,
  });
  final MenuTitle item;
  final Function() onTap;

  @override
  State<SideMenuTitle> createState() => _SideMenuTitleState();
}

class _SideMenuTitleState extends State<SideMenuTitle> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 18),
          child: Divider(
            color: Color.fromRGBO(255, 255, 255, 0.1),
            height: 1,
          ),
        ),
        MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Stack(
            children: [
              if (isHovered)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      // ignore: prefer_const_constructors
                      color: Color.fromARGB(255, 255, 154, 38), // Màu khi hover
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ListTile(
                onTap: widget.onTap,
                leading: Container(
                  width: 235,
                  height: 34,
                  child: Row(
                    children: [
                      Image.asset(
                        widget.item.urlIcon,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.item.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
