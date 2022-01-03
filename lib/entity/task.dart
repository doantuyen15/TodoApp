import 'package:floor/floor.dart';

@entity
class Task {
  @PrimaryKey(autoGenerate: true)
  int? id;
  @ColumnInfo(name: "taskName")
  String taskName;
  @ColumnInfo(name: "isComplete")
  bool isComplete;

  Task(this.taskName, this.isComplete, [this.id]);

}