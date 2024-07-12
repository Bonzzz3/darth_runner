import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/helper/helper_methods.dart';
import 'package:darth_runner/widgets/comment.dart';
import 'package:darth_runner/widgets/comment_button.dart';
import 'package:darth_runner/widgets/delete_button.dart';
import 'package:darth_runner/widgets/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WallPost extends StatefulWidget {
  final String comName;
  final String message;
  final String user;
  final String userEmail;
  final String time;
  final String postId;
  final List<String> likes;

  const WallPost({
    super.key,
    required this.comName,
    required this.message,
    required this.user,
    required this.userEmail,
    required this.time,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => WallPostState();
}

class WallPostState extends State<WallPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef = FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.comName)
        .collection('User Posts')
        .doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //add a comment
  void addComment(String commentText) {
    // add username
    FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.comName)
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentedName": currentUser.displayName,
      "CommentTime": Timestamp.now()
    });
  }

  //show dialog box
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add Comment"),
              content: TextField(
                controller: _commentTextController,
                decoration:
                    const InputDecoration(hintText: "Write a comment.."),
              ),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _commentTextController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  child: const Text("Cancel"),
                ),

                //save button
                TextButton(
                  onPressed: () {
                    if (_commentTextController.text.isNotEmpty) {
                      addComment(_commentTextController.text);
                      Navigator.pop(context);
                      _commentTextController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: const Text("Post"),
                ),
              ],
            ));
  }

  //delete post
  void deletePost() {
    //show dialog to confirm
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
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
              final commentDocs = await FirebaseFirestore.instance
                  .collection("Communities")
                  .doc(widget.comName)
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();
              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("Communities")
                    .doc(widget.comName)
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }

              FirebaseFirestore.instance
                  .collection("Communities")
                  .doc(widget.comName)
                  .collection("User Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => log("post deleted"))
                  .catchError(
                      (error) => log("failed to delete post: $error"));
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 25),

          // seperate content with cancel button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // main post message and user and time
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message,
                      style: const TextStyle(fontSize: 26),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),

              // delete button
              if (widget.userEmail == currentUser.email)
                DeleteButton(
                  onTap: deletePost,
                ),
            ],
          ),

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
          ),

          const SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //like button
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(
                width: 20,
              ),

              //comment button
              Column(
                children: [
                  CommentButton(
                    onTap: showCommentDialog,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Communities")
                        .doc(widget.comName)
                        .collection("User Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String count = snapshot.data!.size.toString();
                        return Text(
                          count,
                          style: const TextStyle(color: Colors.grey),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          //comment lists
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Communities")
                  .doc(widget.comName)
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // final post = snapshot.data!.docs[index];
                //       return ListView.builder(
                //         itemCount: snapshot.data!.docs.length,
                //         itemBuilder: (context, index) {
                //           final post = snapshot.data!.docs[index];
                //           return WallPost(
                //             comName: widget.comName,
                //             message: post['Message'],
                //             user: post['Username'],
                //             time: formatDate(post['TimeStamp']),
                //             postId: post.id,
                //             likes: List<String>.from(post['Likes'] ?? []),
                //           );
                //         },
                //       );

                // return ListView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemBuilder: (context, index) {
                //       final commentData = snapshot.data!.docs[index];
                //       return Comment(
                //         comName: widget.comName,
                //         postId: widget.postId,
                //         commentId: commentData.id,
                //         text: commentData["CommentText"],
                //         user: commentData["CommentedName"],
                //         time: formatDate(commentData["CommentTime"]),
                //       );
                //     });

                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data();

                    return Comment(
                      comName: widget.comName,
                      postId: widget.postId,
                      text: commentData["CommentText"],
                      user: commentData["CommentedName"],
                      time: formatDate(commentData["CommentTime"]),
                    );
                  }).toList(),
                );
              })
        ],
      ),
    );
  }
}
