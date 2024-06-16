import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/helper/helper_methods.dart';
import 'package:darth_runner/widgets/text_fill.dart';
import 'package:darth_runner/widgets/wall_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeSocial extends StatefulWidget {
  const HomeSocial({super.key});

  @override
  State<HomeSocial> createState() => _HomeSocialState();
}

class _HomeSocialState extends State<HomeSocial> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'Username': currentUser.displayName,
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "The Wall",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            //fontSize: 28,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .orderBy("TimeStamp", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return WallPost(
                              message: post['Message'],
                              user: post['Username'],
                              time: formatDate(post['TimeStamp']),
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFill(
                              controller: textController,
                              hintText: "Write something on the Wall..",
                              obscureText: false)),
                      IconButton(
                          onPressed: postMessage,
                          icon: const Icon(
                            Icons.arrow_circle_up,
                            color: Colors.white,
                            size: 38,
                          ))
                    ],
                  ),
                ),

                //logged in as user
                Text(
                  "Logged in as: ${currentUser.displayName}, ${currentUser.email!}",
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
