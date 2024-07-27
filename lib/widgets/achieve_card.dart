import 'package:flutter/material.dart';

class AchieveCard extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final bool? isCompleted;
  const AchieveCard({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    this.isCompleted = false,
  });

  @override
  State<AchieveCard> createState() => _AchieveCardState();
}

class _AchieveCardState extends State<AchieveCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2),
      ),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image
          CircleAvatar(
            minRadius: 30,
            maxRadius: 30,
            backgroundColor: Colors.purple[100],
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(widget.image),
            ),
          ),

          const SizedBox(
            width: 5,
          ),

          // title and description
          SizedBox(
            //height: 50,
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // status
          widget.isCompleted!
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
