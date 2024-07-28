import 'package:darth_runner/recommendation/recom_diet.dart';
import 'package:darth_runner/recommendation/recom_run.dart';
import 'package:flutter/material.dart';

class RecomHome extends StatefulWidget {
  const RecomHome({super.key});

  @override
  State<RecomHome> createState() => _RecomHomeState();
}

class _RecomHomeState extends State<RecomHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          //elevation: 0,
          title: const Text(
            'Recommended Plans',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          //centerTitle: true,
          //automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.run_circle_outlined,
                  size: 32,
                ),
                child: Text(
                  "RUN",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.food_bank,
                  size: 32,
                ),
                child: Text(
                  "DIET",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
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
          child: const SafeArea(
            child: TabBarView(
              children: <Widget>[
                RecomRun(),
                RecomDiet(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
