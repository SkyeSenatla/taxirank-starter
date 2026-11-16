import 'package:intl/intl.dart';

String formatRankTime(DateTime utc) => DateFormat(
  'HH:mm',
).format(utc.toUtc().add(const Duration(hours: 2)));