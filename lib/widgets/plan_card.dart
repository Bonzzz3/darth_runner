import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/widgets/delete_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatefulWidget {
  final String userEmail;
  final String planName;
  final String title;
  final String planContent;
  final String time;
  final String planId;
  const PlanCard({
    super.key,
    required this.userEmail,
    required this.planName,
    required this.title,
    required this.planContent,
    required this.planId,
    required this.time,
  });

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  // Text editing controllers
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.planContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // edit plan
  void editPlan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Plan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: "Content"),
              maxLines: null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String newTitle = _titleController.text.trim();
              String newContent = _contentController.text.trim();
              if (newTitle.isNotEmpty && newContent.isNotEmpty) {
                usersCollection
                    .doc(currentUser.email)
                    .collection(widget.planName)
                    .doc(widget.planId)
                    .update({
                      'PlanTitle': newTitle,
                      'Plan': newContent,
                    })
                    .then((value) => log("post updated"))
                    .catchError(
                        (error) => log("failed to update post: $error"));
              }
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  //delete plan
  void deletePlan() {
    //show dialog to confirm
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Plan"),
        content: const Text("Are you sure you want to delete this plan?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              usersCollection
                  .doc(currentUser.email)
                  .collection(widget.planName)
                  .doc(widget.planId)
                  .delete()
                  .then((value) => log("post deleted"))
                  .catchError((error) => log("failed to delete post: $error"));
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
            },
            child: const Text("Delete"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        // edit button
                        GestureDetector(
                          onTap: editPlan,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // delete button
                        DeleteButton(
                          onTap: deletePlan,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.planContent),
                const SizedBox(height: 5),
              ],
            ),
            Text(
              widget.time,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
