import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  LikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        size: 30,
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
