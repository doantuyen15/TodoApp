import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:untitled/dao/taskdao.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/entity/task.dart';
import 'package:get/get.dart';

class AllTodoScreen extends StatefulWidget {
  const AllTodoScreen({Key? key}) : super(key: key);

  @override
  _AllTodoScreenState createState() => _AllTodoScreenState();
}

class _AllTodoScreenState extends State<AllTodoScreen> {
  // late TaskDAO dao;
  TaskDAO dao = Get.find();

  // @override
  // void initState() {
  //   super.initState();
  //   print("initState AllTodo");
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print("didChangeDependencies alltodoscreen");
  //   setState(() {
  //
  //   });
  // }

  // Future<void> iniDB() async {
  //   var db =
  //       await $FloorAppDatabase.databaseBuilder('task_database.db').build();
  //   dao = db.taskDAO;
  //   print("initDB: dao = $dao");
  // }
  //
  // Future<List<Task>> getListData() async {
  //   await iniDB();
  //   return dao.getAllTask();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dao.getAllTask(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var db = snapshot.data as List<Task>;
            return ListView.separated(
              separatorBuilder: (context, index) =>
                  (const Divider(color: Colors.black)),
              padding: const EdgeInsets.all(4),
              itemCount: db.length,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var _task = db[index];
                return Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 2,
                          onPressed: (context) async {
                            // final task = Task(taskName: _task.taskName, isComplete: !_task.isComplete);
                            await dao.updateTask(
                                _task.taskName, !_task.isComplete, _task.id!);
                            setState(() {});
                          },
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                          icon: Icons.update,
                          label: 'Update',
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            await dao.deleteTask(_task.taskName, _task.id!);
                            setState(() {});
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ],
                    ),
                    child: ListTile(
                        title: Text(_task.taskName),
                        trailing: Icon(
                            _task.isComplete
                                ? Icons.check_circle_outline
                                : Icons.highlight_off,
                            color: _task.isComplete
                                ? Colors.lightBlue
                                : Colors.red,
                            size: 30.0)));
                // return CheckboxListTile(
                //   title: Text(_task.taskName),
                //   value: _task.isComplete,
                //   onChanged: (val) async {
                //     _task.isComplete = val!;
                //     /*final task = Task(
                //         taskName: _task.taskName,
                //         isComplete: val!
                //     );*/
                //     await dao.updateTask(_task);
                //     // updateDB(task);
                //     setState(() {
                //       // updateDB(_task);
                //     }
                //     );
                //     /*async {
                //             final task = Task(
                //                 taskName: _task.taskName,
                //                 isComplete: _task.isComplete
                //             );
                //             await dao.updateTask(task);
                //             // _task.isComplete = val!;
                //       },*/
                //     // );
                //   },
                // );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

// Future<void> updateDB(Task task) async {
//   await dao.updateTask(task);
// }
}
