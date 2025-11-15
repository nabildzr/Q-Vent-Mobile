import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

Widget topProfile() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),

            child: Container(
              clipBehavior: Clip.antiAlias,

              decoration: BoxDecoration(),
              height: 70,
              width: 70,
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSMUi9wHqia_68xlAU7vP3E3sxn5K0KS-nUvBZk5jSJ54p8FPnw20uYV5yxNgF59DZoqc&usqp=CAU',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Welcome!",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "Nabil Dzikrika",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ],
          ),
        ],
      ),
      Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(217, 217, 217, 1000),
              ),
              child: Iconify(Ic.baseline_notifications),
            ),
          ),
        ],
      ),
    ],
  );
}
