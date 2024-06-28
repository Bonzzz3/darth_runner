import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  final dateFormatter = DateFormat('dd-MM-yyyy');
  final timeFormatter = DateFormat('HH:mm');

  final formattedDate = dateFormatter.format(dateTime);
  final formattedTime = timeFormatter.format(dateTime);

  String formattedData = "$formattedDate  $formattedTime";

  return formattedData;
}
