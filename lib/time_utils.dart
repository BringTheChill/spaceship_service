import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

final kTime = LinkedHashMap<DateTime, List<TimeOfDay>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kTimeSource);

// Ore ocupate
final _kTimeSource = {
  kToday: [
    TimeOfDay.fromDateTime(
      DateTime(kToday.year, kToday.month, kToday.day, 12, 00),
    ),
  ],
  kToday.add(const Duration(days: 1)): [
    TimeOfDay.fromDateTime(
      DateTime(kToday.year, kToday.month, kToday.day, 15, 00),
    ),
  ],
};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
