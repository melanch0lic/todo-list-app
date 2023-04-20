import 'package:hive/hive.dart';

part 'record_hive.g.dart';

@HiveType(typeId: 1)
class Record {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime recordDate;

  @HiveField(2)
  bool? isChecked;

  Record({required this.name, required this.recordDate, required this.isChecked});
}
