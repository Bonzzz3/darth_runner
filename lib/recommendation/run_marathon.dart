import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/helper/helper_methods.dart';
import 'package:darth_runner/recommendation/player.dart';
import 'package:darth_runner/widgets/plan_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RunMarathon extends StatefulWidget {
  const RunMarathon({super.key});

  @override
  State<RunMarathon> createState() => _RunMarathonState();
}

class _RunMarathonState extends State<RunMarathon> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  final textController = TextEditingController();
  Future<void>? _launched;
  final videoUrls = [
    'https://www.youtube.com/watch?v=XzGHq_lyZ88',
    'https://www.youtube.com/watch?v=N1zcps7nQaI',
    'https://www.youtube.com/watch?v=Q-Hfw4gADx4',
    'https://www.youtube.com/watch?v=SLs1dGvjckg',
    'https://www.youtube.com/watch?v=XlpUPYF9gHY'
  ];
  final List<Uri> websiteUrls = [
    Uri.parse(
        'https://www.rei.com/learn/expert-advice/training-for-your-first-marathon.html'),
    Uri.parse(
        'https://www.runnersworld.com/uk/training/marathon/a36969929/successful-marathon-training-rules/'),
    Uri.parse(
        'https://www.runtothefinish.com/transitioning-from-half-to-full-marathon/'),
  ];
  final List<String> websiteTitles = [
    'Training For Your First Marathon',
    'Successful Marathon Training Rules',
    'Transitioning From Half To Full Marathon',
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
      usersCollection.doc(currentUser.email).collection("Marathon Plans").add({
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
          'Marathon Plans',
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
                        .collection('Marathon Plans')
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
                                  planName: "Marathon Plans",
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
                  "Tips for Marathon",
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
                            '1.	Variety & Consistency: Stick to a training plan you enjoy and can consistently follow, focusing on frequent easy and steady runs.\n2.	Long Runs: Limit longest runs to 2:30-3:15 to avoid starting the marathon tired.\n3.	Training Volume: Aim for four to five runs a week, with a midweek run of 75-90 minutes.\n4.	Race Pace Practice: Incorporate race-pace runs in the final 8-10 weeks of training.\n5.	Energy Management: Alternate between high and low-intensity efforts within runs to teach your body fuel efficiency.\n6.	Cross-Training: Use non-running activities like cycling and aqua-jogging to increase fitness while reducing injury risk.\n7.	Hill Training: Include hill runs to improve strength and cardiovascular fitness.\n8.	Fuelling Strategy: Practice your race-day fuelling with gels or other options during long runs.\n9.	Strength Training: Include exercises like squats and planks to maintain form and pace during the marathon.\n10.	Tapering: Reduce training volume gradually in the last three to four weeks before the race.\n11.	Recovery: Balance hard training with rest and recovery to maximize fitness gains.\n12.	Nutrition: Eat a balanced diet rich in carbs before key sessions and include a post-run recovery snack.\n13.	Enjoy the Process: Stay social, keep a positive mindset, and enjoy your training journey.\n14.	Mental Preparation: Build mental resilience through positive self-talk, race-day rehearsals, and focusing on small training goals.\n15.	Race Day Routine: Follow familiar routines, stay calm, and arrive early to avoid rushing.\n16.	Energy Preservation: Conserve energy at the start, aiming to feel strong at 30km/18 miles.\n17.	Final Push: Focus on the current mile, maintain good posture, and dedicate miles to loved ones for motivation.\nRefer to https://www.runnersworld.com/uk/training/marathon/a36969929/successful-marathon-training-rules/'),
                      )),
                    ],
                  ),
                ),

                // Youtube thumbnail
                const Text(
                  "Recommended Marathon Videos and Tips",
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
