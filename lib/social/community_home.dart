import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/helper/helper_methods.dart';
import 'package:darth_runner/widgets/community_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityHome extends StatefulWidget {
  const CommunityHome({super.key});

  @override
  State<CommunityHome> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  // final textController = TextEditingController();

  Future<void> createNewCommunity() async {
    // Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Create new Community",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter Community name",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    //update in Firestore
    if (newValue.trim().isNotEmpty) {
      FirebaseFirestore.instance.collection("Communities").doc(newValue).set({
        'Community Name': newValue,
        'Username': currentUser.displayName,
        'UserEmail': currentUser.email,
        'TimeStamp': Timestamp.now(),
      });
    }
    //}
    // if (textController.text.isNotEmpty) {
    //   FirebaseFirestore.instance.collection("Communities").doc(textController.text).set({
    //     'Title': textController.text,
    //     'User': currentUser.displayName,
    //     'TimeStamp': Timestamp.now(),
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Communities",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            //fontSize: 28,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        actions: [
          IconButton(
              onPressed: createNewCommunity,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
          const SizedBox(
            width: 20,
          ),
        ],
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
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Communities")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return CommunityCard(
                          comName: post['Community Name'],
                          username: post['Username'],
                          userEmail: post['UserEmail'],
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
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
              //logged in as user
              Text(
                "Logged in as: ${currentUser.displayName}, ${currentUser.email!}",
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
