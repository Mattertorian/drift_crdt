import 'package:drift/drift.dart';
import 'package:drift_crdt/crdt_table.dart';
import 'package:drift_crdt/drift_crdt.dart';
import 'package:sqlite_crdt/sqlite_crdt.dart';

part 'main.g.dart';

Future<void> main() async {
  final db = AppDatabase();

  await db.insert(description: 'A task description');

  final tasks = await db.managers.tasks.get();

  print('Found ${tasks.length} Tasks');
  print('${tasks.map((t) => '$t\n').join()}');
}

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return CrdtQueryExecutor.inMemory();
    // return CrdtQueryExecutor.open(
    //     path: '/Users/mattertorian/development/apps/drift_crdt/db.sqlite');
  }

  SqliteCrdt get crdt => (executor as CrdtQueryExecutor).crdt!;
  Hlc get hlc => crdt.canonicalTime;
  String get _hlcString => hlc.toString();
  String get nodeId => crdt.nodeId;

  Future<void> insert({
    required String description,
  }) async {
    try {
      await managers.tasks.create((c) => c(
            description: description,
            hlc: _hlcString,
            modified: _hlcString,
            nodeId: nodeId,
            isDeleted: false,
          ));
    } catch (e) {
      print('Failed to insert task. Error was:\n$e');
    }
  }
}

class Tasks extends CrdtTable {
  TextColumn get description => text()();
  BoolColumn get completed => boolean().clientDefault(() => false)();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

extension CrdtCompanionX<T> on UpdateCompanion<T> {}
