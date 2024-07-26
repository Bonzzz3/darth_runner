import 'package:hive/hive.dart';

part 'rundata.g.dart';

@HiveType(typeId: 1)
class Rundata {
  Rundata({
    required this.hiveDistance,
    required this.hiveDate,
    required this.hiveTime,
    required this.hivePace,
    required this.hiveRunTitle
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

  
}