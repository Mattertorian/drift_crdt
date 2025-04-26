import 'package:drift/drift.dart';

class CrdtTable extends Table {
  BoolColumn get isDeleted => boolean()();
  TextColumn get hlc => text()();
  TextColumn get modified => text()();
  TextColumn get nodeId => text()();
}
