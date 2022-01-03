import 'dart:async';

import 'package:floor/floor.dart';
import 'package:untitled/dao/taskdao.dart';
import 'package:untitled/entity/task.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version:1, entities:[Task])
abstract class AppDatabase extends FloorDatabase{
  TaskDAO get taskDAO;
}