// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TaskDAO? _taskDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `taskName` TEXT NOT NULL, `isComplete` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TaskDAO get taskDAO {
    return _taskDAOInstance ??= _$TaskDAO(database, changeListener);
  }
}

class _$TaskDAO extends TaskDAO {
  _$TaskDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _taskInsertionAdapter = InsertionAdapter(
            database,
            'Task',
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'taskName': item.taskName,
                  'isComplete': item.isComplete ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Task> _taskInsertionAdapter;

  @override
  Stream<List<Task>> getAllTask() {
    return _queryAdapter.queryListStream('SELECT * FROM Task',
        mapper: (Map<String, Object?> row) => Task(row['taskName'] as String,
            (row['isComplete'] as int) != 0, row['id'] as int?),
        queryableName: 'Task',
        isView: false);
  }

  @override
  Stream<List<Task>> getTaskByState(bool isComplete) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Task WHERE isComplete=?1',
        mapper: (Map<String, Object?> row) => Task(row['taskName'] as String,
            (row['isComplete'] as int) != 0, row['id'] as int?),
        arguments: [isComplete ? 1 : 0],
        queryableName: 'Task',
        isView: false);
  }

  @override
  Future<void> updateTask(String taskName, bool isComplete, int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Task SET isComplete = ?2 WHERE taskName = ?1 AND id = ?3',
        arguments: [taskName, isComplete ? 1 : 0, id]);
  }

  @override
  Future<void> deleteTask(String taskName, int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Task WHERE taskName = ?1 AND id = ?2',
        arguments: [taskName, id]);
  }

  @override
  Future<void> insertTask(Task task) async {
    await _taskInsertionAdapter.insert(task, OnConflictStrategy.abort);
  }
}
