import 'dart:math';

import 'package:dart_ndk/extensions.dart';

int getUnixTimestampWithinOneWeek() {
  final now = DateTime.now();
  final weekBefore = now.subtract(
    const Duration(days: 7),
  );

  final random = Random();

  return weekBefore.toSecondsSinceEpoch() +
      random.nextInt(
          now.toSecondsSinceEpoch() - weekBefore.toSecondsSinceEpoch());
}
