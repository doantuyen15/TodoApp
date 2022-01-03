import 'package:floor/floor.dart';
import 'package:untitled/entity/task.dart';

@dao
abstract class TaskDAO{
  @Query('SELECT * FROM Task')
  Stream<List<Task>> getAllTask();

  @Query('SELECT * FROM Task WHERE isComplete=:isComplete')
  Stream<List<Task>> getTaskByState(bool isComplete);

  @insert
  Future<void> insertTask(Task task);

  @Query('UPDATE Task SET isComplete = :isComplete WHERE taskName = :taskName AND id = :id')
  Future<void> updateTask(String taskName, bool isComplete, int id);

  @Query('DELETE FROM Task WHERE taskName = :taskName AND id = :id')
  Future<void> deleteTask(String taskName, int id);

}