// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:flutter/material.dart';

class FoodCategoryWidget extends StatelessWidget {
  final String icon;
  final String name;
  const FoodCategoryWidget({
    Key? key,
    required this.icon,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      margin: const EdgeInsets.only(right: 12),
      borderRadius: BorderRadius.circular(25),
      opacity: 0.35,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
