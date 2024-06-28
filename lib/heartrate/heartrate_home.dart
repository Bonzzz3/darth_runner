import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:heart_bpm/chart.dart';

class HeartrateHome extends StatefulWidget {
  const HeartrateHome({super.key});

  @override
  State<HeartrateHome> createState() => _HeartrateHomeState();
}

class _HeartrateHomeState extends State<HeartrateHome> {
  List<SensorValue> data = [];
  int? bpmValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Heart BPM Demo'),
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Cover both the camera and flash with your finger",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 22,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  size: 88,
                  color: Colors.red,
                ),
                HeartBPMDialog(
                  context: context,
                  onRawData: (value) {
                    setState(() {
                      if (data.length == 100) {
                        data.removeAt(0);
                      }
                      data.add(value);
                    });
                  },
                  onBPM: (value) => setState(() {
                    bpmValue = value;
                  }),
                  child: Text(
                    bpmValue?.toString() ?? "-",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
  // List<SensorValue> data = [];
  // List<SensorValue> bpmValues = [];
  // // Widget chart = BPMChart(data);

  // bool isBPMEnabled = false;
  // Widget? dialog;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey.shade100,
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       title: Text('Heart BPM Demo'),
  //       iconTheme: const IconThemeData(color: Colors.white, size: 30),
  //     ),
  //     body: Column(
  //       children: [
  //         isBPMEnabled
  //             ? dialog = HeartBPMDialog(
  //                 context: context,
  //                 showTextValues: true,
  //                 borderRadius: 10,
  //                 onRawData: (value) {
  //                   setState(() {
  //                     if (data.length >= 100) data.removeAt(0);
  //                     data.add(value);
  //                   });
  //                   //chart = BPMChart(data);
  //                 },
  //                 onBPM: (value) => setState(() {
  //                   if (bpmValues.length >= 100) bpmValues.removeAt(0);
  //                   bpmValues.add(SensorValue(
  //                       value: value.toDouble(), time: DateTime.now()));
  //                 }),
  //                 // sampleDelay: 1000 ~/ 20,
  //                 // child: Container(
  //                 //   height: 50,
  //                 //   width: 100,
  //                 //   child: BPMChart(data),
  //                 // ),
  //               )
  //             : SizedBox(),
  //         isBPMEnabled && data.isNotEmpty
  //             ? Container(
  //                 decoration: BoxDecoration(border: Border.all()),
  //                 height: 180,
  //                 child: BPMChart(data),
  //               )
  //             : SizedBox(),
  //         isBPMEnabled && bpmValues.isNotEmpty
  //             ? Container(
  //                 decoration: BoxDecoration(border: Border.all()),
  //                 constraints: BoxConstraints.expand(height: 180),
  //                 child: BPMChart(bpmValues),
  //               )
  //             : SizedBox(),
  //         Center(
  //           child: ElevatedButton.icon(
  //             icon: Icon(Icons.favorite_rounded),
  //             label: Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
  //             onPressed: () => setState(() {
  //               if (isBPMEnabled) {
  //                 isBPMEnabled = false;
  //                 // dialog.
  //               } else
  //                 isBPMEnabled = true;
  //             }),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

