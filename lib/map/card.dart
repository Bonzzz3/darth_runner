import 'package:darth_runner/database/rundata.dart';
import 'package:flutter/material.dart';

class CardData extends StatelessWidget {
  const CardData({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(9),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(Rundata?.hiveRunTitle)
              ],
            )
          ],
        )
        
      ),
    );
  
  
  
  
  }



}