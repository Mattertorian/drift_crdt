import 'package:drift/drift.dart';

/// All tables should extend [CrdtTable] rather than the regular [Table].
///
/// Consider also adding an index by annotating with
/// ```dart
/// @TableIndex(name: 'hlc', columns: {#hlc})
/// class MyTable extends CrdtTable {
///   ...
/// }
/// ```
class CrdtTable extends Table {
  BoolColumn get isDeleted => boolean()();
  TextColumn get hlc => text()();
  TextColumn get modified => text()();
  TextColumn get nodeId => text()();
}
