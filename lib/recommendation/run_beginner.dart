import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/helper/helper_methods.dart';
import 'package:darth_runner/recommendation/player.dart';
import 'package:darth_runner/widgets/plan_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RunBeginner extends StatefulWidget {
  const RunBeginner({super.key});

  @override
  State<RunBeginner> createState() => _RunBeginnerState();
}

class _RunBeginnerState extends State<RunBeginner> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  final textController = TextEditingController();
  Future<void>? _launched;
  final videoUrls = [
    'https://www.youtube.com/watch?v=kVnyY17VS9Y',
    'https://www.youtube.com/watch?v=5umbf4ps0GQ',
    'https://www.youtube.com/watch?v=uG-HACPcmvk',
    'https://www.youtube.com/watch?v=7a2pAOnDkTs',
    'https://www.youtube.com/watch?v=wM-HWJscB_w'
  ];
  final List<Uri> websiteUrls = [
    Uri.parse(
        'https://www.runnersworld.com/uk/training/beginners/a772727/how-to-start-running-today/'),
    Uri.parse(
        'https://www.runnersworld.com/uk/training/beginners/a40088632/running-tips-for-beginners/'),
    Uri.parse('https://zenhabits.net/beginners-guide-to-running/'),
  ];
  final List<String> websiteTitles = [
    'How To Start Running Today',
    '14 running tips for beginners',
    'Beginner’s Guide to Running',
  ];

  Future<void> _launchInAppWithBrowserOptions(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  Future<void> createNewPlan() async {
    String newTitle = "";
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Create new Plan",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Title for your Plan",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                newTitle = value;
              },
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Type in your Plan",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                newValue = value;
              },
            ),
          ],
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

    if (newTitle.trim().isNotEmpty && newValue.trim().isNotEmpty) {
      usersCollection.doc(currentUser.email).collection("Beginner Plans").add({
        'Username': currentUser.displayName,
        'UserEmail': currentUser.email,
        'PlanTitle': newTitle,
        'Plan': newValue,
        'TimeStamp': Timestamp.now(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        title: const Text(
          'Beginner Plans',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient red blue wp.png"),
              fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Plans/Notes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: createNewPlan,
                      child: const Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // User's plans
                Scrollbar(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: usersCollection
                        .doc(currentUser.email)
                        .collection('Beginner Plans')
                        .orderBy('TimeStamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data?.size == 0) {
                        return const Center(
                          child: Text(
                            "Add your own plans!",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return Container(
                          height: 400,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final post = snapshot.data!.docs[index];
                              final title = post['PlanTitle'];
                              final planContent = post['Plan'];
                              final time = formatDate(post['TimeStamp']);
                              final planId = post.id;
                              // Plan card
                              return PlanCard(
                                  userEmail: post['UserEmail'],
                                  planName: "Beginner Plans",
                                  title: title,
                                  planContent: planContent,
                                  planId: planId,
                                  time: time);
                            },
                          ),
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
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                const Text(
                  "Recommended Running Plans",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            //border: Border.all(color: Colors.black, width: 5),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                              "Here’s a simple 30/30 plan to get you going, featuring 30 minutes of exercise for the first 30 days. It is a routine similar to one that the late Chuck Cornett, a coach from Orange Park, Florida, used with beginning runners. \n1. Walk out the door and go 15 minutes in one direction, turn around, and return 15 minutes to where you started: 30 minutes total.2. For the first 10 minutes of your workout, it is obligatory that you walk: No running!\n3. For the last 5 minutes of your workout, it is obligatory that you walk: Again, no running!\n4. During the middle 15 minutes of the workout, you are free to jog or run–as long as you do so easily and do not push yourself.\n5. Here’s how to run during those middle 15 minutes: Jog for 30 seconds, walk until you are recovered, jog 30 seconds again. Jog, walk. Jog, walk. Jog, walk.\n6. Once comfortable jogging and walking, adapt a 30/30 pattern: jogging 30 seconds, walking 30 seconds, etc.\nBy https://www.halhigdon.com/training-programs/more-training/beginning-runners-guide/"),
                        ),
                      ),
                    ],
                  ),
                ),

                // Youtube thumbnail
                const Text(
                  "Recommended Beginner Videos and Tips",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                SizedBox(
                  height: 100,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: videoUrls.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final videoID =
                            YoutubePlayer.convertUrlToId(videoUrls[index]);
                        return Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PLayerScreen(videoId: videoID)));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    YoutubePlayer.getThumbnail(
                                        videoId: videoID!),
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 80,
                                  ),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                const Text(
                  "Websites",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: websiteUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () => setState(() {
                          _launched = _launchInAppWithBrowserOptions(
                              websiteUrls[index]);
                        }),
                        child: Text(
                          websiteTitles[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                FutureBuilder<void>(future: _launched, builder: _launchStatus),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
