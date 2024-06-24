import 'package:flutter/material.dart';

class AchieveCard extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  const AchieveCard({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  State<AchieveCard> createState() => _AchieveCardState();
}

class _AchieveCardState extends State<AchieveCard> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        //border: Border.all(color: Colors.black, width: 5),
      ),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          CircleAvatar(
            minRadius: 30,
            maxRadius: 30,
            foregroundImage: AssetImage(widget.image),
          ),

          const SizedBox(
            width: 15,
          ),

          // title and description
          SizedBox(
            //height: 50,
            width: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.description,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),

          // status
          _isCompleted
              ? const Text(
                  "Completed",
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                )
              : const Text(
                  "Incomplete",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
        ],
      ),
    );
  }
}
