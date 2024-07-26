import 'package:flutter/material.dart';

class DistanceCircle extends StatelessWidget {
  final double distcircle;

  const DistanceCircle({required this.distcircle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        value: distcircle,
        strokeWidth: 2,
        color: Colors.lightBlueAccent,
      ),
    );
  }
}