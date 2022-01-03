import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:untitled/dao/taskdao.dart';
import 'package:untitled/entity/task.dart';

class IncompleteScreen extends StatefulWidget {
  const IncompleteScreen({Key? key}) : super(key: key);

  @override
  _IncompleteScreenState createState() => _IncompleteScreenState();
}

class _IncompleteScreenState extends State<IncompleteScreen> {
  final TaskDAO dao = Get.find();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dao.getTaskByState(false),
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
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
