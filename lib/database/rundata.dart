
// IMPORTANT HIVE INITIALIZATION
// DO NOT EDIT rundata.g.dart MANUALLY.
// USE BUILD COMMAND IN TERMINAL


import 'package:hive/hive.dart';

part 'rundata.g.dart';

@HiveType(typeId: 1)
class Rundata extends HiveObject{
  Rundata({
    required this.hiveDistance,
    required this.hiveDate,
    required this.hiveTime,
    required this.hivePace,
    required this.hiveRunTitle,
    this.snapshotUrl
  });
  
  @HiveField(0)
  double hiveDistance;

  @HiveField(1)
  String hiveTime;

  @HiveField(2)
  double hivePace;

  @HiveField(3)
  DateTime hiveDate;

  @HiveField(4)
  String hiveRunTitle;

  @HiveField(5)
  String? snapshotUrl;

  Map<String, dynamic> toMap() {
    return {
      'hiveDistance': hiveDistance,
      'hiveDate': hiveDate,
      'hiveTime': hiveTime,
      'hivePace': hivePace,
      'hiveRunTitle': hiveRunTitle,
      'snapshotUrl': snapshotUrl,
    };
  }

  
}