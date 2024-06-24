import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/widgets/delete_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final String comName;
  final String postId;
  //final String commentId;
  final String text;
  final String user;
  final String time;
  const Comment({
    super.key,
    required this.comName,
    required this.postId,
    //required this.commentId,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  // void deleteComment() {
  //   //show dialog to confirm
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Delete Comment"),
  //       content: const Text("Are you sure you want to delete this comment?"),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Cancel"),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             FirebaseFirestore.instance
  //                 .collection("Communities")
  //                 .doc(widget.comName)
  //                 .collection("User Posts")
  //                 .doc(widget.postId)
  //                 .collection("Comments")
  //                 .doc(widget.commentId)
  //                 .delete()
  //                 .then((value) => print("post deleted"))
  //                 .catchError(
  //                     (error) => print("failed to delete post: $error"));
  //             Navigator.pop(context);
  //           },
  //           child: const Text("Delete"),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              // if (widget.user == currentUser.displayName)
              //   DeleteButton(
              //     onTap: deleteComment,
              //   ),
            ],
          ),
          //user and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //user
              Text(
                widget.user,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              //time
              Text(
                widget.time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
