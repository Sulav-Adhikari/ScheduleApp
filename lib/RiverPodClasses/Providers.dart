import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../Database/dbhelper.dart';

final dbProvider = Provider<DBHelper>((ref) => DBHelper());
final notesProvider = FutureProvider<dynamic>((ref) {
  return ref.read(dbProvider).getNotes();
});
final dateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedTimeProvider = StateProvider<String>(
    (ref) => DateFormat('hh:mm a').format(DateTime.now()));
