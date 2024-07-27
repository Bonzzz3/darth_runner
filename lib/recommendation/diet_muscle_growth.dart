import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/helper/helper_methods.dart';
import 'package:darth_runner/recommendation/player.dart';
import 'package:darth_runner/widgets/plan_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DietMuscleGrowth extends StatefulWidget {
  const DietMuscleGrowth({super.key});

  @override
  State<DietMuscleGrowth> createState() => _DietMuscleGrowthState();
}

class _DietMuscleGrowthState extends State<DietMuscleGrowth> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  final textController = TextEditingController();
  Future<void>? _launched;
  final videoUrls = [
    'https://www.youtube.com/watch?v=osqvOUJjaCo',
    'https://www.youtube.com/watch?v=RFGH6voGrI8',
    'https://www.youtube.com/watch?v=Qvf9kgkPjs4',
    'https://www.youtube.com/watch?v=yRDI30HrjVQ',
    'https://www.youtube.com/watch?v=oPRrl-ZhrJQ'
  ];
  final List<Uri> websiteUrls = [
    Uri.parse(
        'https://www.everyoneactive.com/content-hub/nutrition/building-muscle/'),
    Uri.parse('https://www.healthline.com/nutrition/26-muscle-building-foods'),
    Uri.parse('https://www.healthline.com/nutrition/bodybuilding-meal-plan'),
  ];
  final List<String> websiteTitles = [
    '8 Diet Tips To Help With Building Muscle',
    '26 Foods to Eat to Gain Muscle',
    "What to Eat and Avoid If You're Trying to Build Muscle",
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
      usersCollection
          .doc(currentUser.email)
          .collection("Muscle Growth Plans")
          .add({
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
          'Muscle Growth Plans',
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
                        .collection('Muscle Growth Plans')
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
                                  planName: "Muscle Growth Plans",
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
                              '9 Diet Tips To Gain Muscles:\n1. Consume more calories than you burn\n2. Do not skip meals\n3. Consume more protein\n4. Consume good fats\n5. Drink plenty of water\n6. Eat at least 2 pieces of fruit per day\n7. Avoid sugar and processed foods\n8. Avoid drinking alcohol\n9. Eat complex carbohydrates\n\nhttps://www.tuasaude.com/en/what-to-eat-to-gain-muscle/'),
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
