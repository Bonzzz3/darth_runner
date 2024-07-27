import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/helper/helper_methods.dart';
import 'package:darth_runner/recommendation/player.dart';
import 'package:darth_runner/widgets/plan_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DietRunners extends StatefulWidget {
  const DietRunners({super.key});

  @override
  State<DietRunners> createState() => _DietRunnersState();
}

class _DietRunnersState extends State<DietRunners> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  final textController = TextEditingController();
  Future<void>? _launched;
  final videoUrls = [
    'https://www.youtube.com/watch?v=tj6QGjaq9l8',
    'https://www.youtube.com/watch?v=HcKQfLBzJyY',
    'https://www.youtube.com/watch?v=nssZLkp40fc',
    'https://www.youtube.com/watch?v=nGrpuWjfbbI',
    'https://www.youtube.com/watch?v=vZ5jvoUQS18'
  ];
  final List<Uri> websiteUrls = [
    Uri.parse(
        'https://www.runnersworld.com/uk/nutrition/diet/a39672411/runners-diet/'),
    Uri.parse('https://www.healthline.com/nutrition/runners-diet'),
    Uri.parse('https://www.verywellfit.com/should-i-eat-before-a-run-2911547'),
  ];
  final List<String> websiteTitles = [
    'Everything You Need To Know About Nutrition For Runners',
    'What’s the Best Diet for Runners?',
    "What to Eat Before a Run: Your Guide to a Runner's Diet",
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
      usersCollection.doc(currentUser.email).collection("Runner Plans").add({
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
          'Runner Plans',
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
              image: AssetImage("assets/img/gradient.png"), fit: BoxFit.cover),
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
                        .collection('Runner Plans')
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
                        return SizedBox(
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
                                  planName: "Runner Plans",
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
                  "Tips",
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
                              'A good diet can boost your physical health and help you meet your fitness goals. Make sure your meals emphasize the following basic components:\nFruit and vegetables for vitamins, minerals and antioxidants\nLean protein such as fish, poultry, beans, lentils and tofu\nHealthy fats such as olive oil, avocado and nuts\nHealthy carbohydrates such as rice, whole grain breads/pastas and oatmeal\nIndividuals may have different optimal balances, but in general, people who include running or jogging as part of their fitness regimen should get 60% to 70% of their calories from carbohydrates, with lean protein and healthy fats each accounting for 15% to 20% of their remaining calories.\n\nBy https://www.hopkinsmedicine.org/health/wellness-and-prevention/runners-diet'),
                        ),
                      ),
                    ],
                  ),
                ),

                // Youtube thumbnail
                const Text(
                  "Recommended Diet Videos and Tips",
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
