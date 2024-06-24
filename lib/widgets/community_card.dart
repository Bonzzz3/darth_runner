import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/social/home_social.dart';
import 'package:darth_runner/widgets/delete_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityCard extends StatefulWidget {
  final String comName;
  final String username;
  final String userEmail;
  final String time;
  const CommunityCard(
      {super.key,
      required this.comName,
      required this.username,
      required this.userEmail,
      required this.time});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  void deleteCommunity() {
    //show dialog to confirm
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Community"),
              content:
                  const Text("Are you sure you want to delete this community?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    // delete the posts after deleting comments
                    final postDocs = await FirebaseFirestore.instance
                        .collection("Communities")
                        .doc(widget.comName)
                        .collection("User Posts")
                        .get();
                    for (var doc in postDocs.docs) {
                      //delete comments
                      final commentDocs = await FirebaseFirestore.instance
                          .collection("Communities")
                          .doc(widget.comName)
                          .collection("User Posts")
                          .doc(doc.id)
                          .collection("Comments")
                          .get();
                      for (var docComment in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection("Communities")
                            .doc(widget.comName)
                            .collection("User Posts")
                            .doc(doc.id)
                            .collection("Comments")
                            .doc(docComment.id)
                            .delete();
                      }
                      await FirebaseFirestore.instance
                          .collection("Communities")
                          .doc(widget.comName)
                          .collection("User Posts")
                          .doc(doc.id)
                          .delete();
                    }

                    // finally delete community
                    FirebaseFirestore.instance
                        .collection("Communities")
                        .doc(widget.comName)
                        .delete()
                        .then((value) => print("Community deleted"))
                        .catchError(
                            (error) => print("failed to delete post: $error"));
                    Navigator.pop(context);
                  },
                  child: const Text("Delete"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeSocial(
                      comName: widget.comName,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          //border: Border.all(color: Colors.black, width: 5),
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
                // title, user and time
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),

                // delete button
                if (widget.username == currentUser.displayName)
                  DeleteButton(
                    //onTap: () {},
                    onTap: deleteCommunity,
                  ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //user
                Text(
                  "Created by: ${widget.username}",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
