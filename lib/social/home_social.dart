import 'package:cloud_firestore/cloud_firestore.dart';
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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
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
                            user: post['UserEmail'],
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ' + snapshot.error.toString()),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
              Padding(
                padding: const EdgeInsets.all(25.0),
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
                          color: Colors.white60,
                          size: 38,
                        ))
                  ],
                ),
              ),

              //logged in as user
              Text("Logged in as: " + currentUser.email!),
            ],
          ),
        ),
      ),
    );
  }
}
