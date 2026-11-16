import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/app/app.dart';
import 'package:taxirank/app/retry_policy.dart';

void main() {
  runApp(const ProviderScope(retry: appRetryPolicy, child: TaxiRankApp()));
}
