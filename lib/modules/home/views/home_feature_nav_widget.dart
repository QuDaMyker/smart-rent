import 'package:flutter/material.dart';
import 'package:smart_rent/core/values/app_colors.dart';

class HomeFeatureNavWidget extends StatelessWidget {
  const HomeFeatureNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 205, 203, 203), // Màu của bóng mờ
            blurRadius: 9.0, // Độ mờ của bóng
            spreadRadius: 3.0, // Độ lan rộng của bóng
            offset: Offset(0, 2), // Vị trí độ lệch của bóng
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: primary98,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 25,
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.map_outlined,
                    color: primary40,
                  ),
                  Text('Bản đồ'),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: primary98,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 25,
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.add_to_queue_sharp,
                    color: primary40,
                  ),
                  Text('Đăng bài'),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: primary98,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.timelapse_rounded,
                    color: primary40,
                  ),
                  Text('Đã xem\ngần đây'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}