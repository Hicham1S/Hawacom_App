import 'package:flutter/material.dart';
import '../../constants/colors.dart';

/// Grid menu button (4-dot icon) that triggers the menu drawer
class GridMenuButton extends StatelessWidget {
  final VoidCallback onTap;

  const GridMenuButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: 20,
          height: 20,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: List.generate(4, (index) {
              return Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
