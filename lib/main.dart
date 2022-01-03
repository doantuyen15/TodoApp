import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Screens/alltodoscreen.dart';
import 'package:untitled/Screens/completescreen.dart';
import 'package:untitled/Screens/incompletescreen.dart';
import 'package:untitled/dao/taskdao.dart';
import 'package:untitled/database/database.dart';
import 'package:get/get.dart';

import 'entity/task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('task_database.db').build();
  final dao = database.taskDAO;
  Get.put(dao);

  // runApp(TodoApp(dao: dao));
  runApp(TodoApp());
}
// void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  // const TodoApp({Key? key, required this.dao}) : super(key: key);
  // final TaskDAO dao;
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: HomePage(dao: dao));
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  // const HomePage({Key? key, required this.dao}) : super(key: key);
  // final TaskDAO dao;
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskDAO dao = Get.find();

  // @override
  // void initState() {
  //   super.initState();
  //   builder().whenComplete(() => Get.put(dao));
  // }

  // Future builder() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   final database =
  //       await $FloorAppDatabase.databaseBuilder('task_database.db').build();
  //   dao = database.taskDAO;
  // }

  int selectedIndex = 0;
  Widget _allTodoScreen = AllTodoScreen();
  Widget _completeScreen = CompleteScreen();
  Widget _incompleteScreen = IncompleteScreen();

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      // key: scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
              key: const Key('buttonAddDialog'),
              onPressed: () async {
                // await Get.to(const AddScreen());
                await showCreateTodoDialog(context)
                    .whenComplete(() => setState(() {
                          // selectedIndex = 0;
                        }));
              },
              icon: const Icon(Icons.add))
        ],
        title: const Text('Todo App'),
        centerTitle: true,
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: "All",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: "Complete",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outline_blank),
            label: "Incomplete",
          )
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return _allTodoScreen;
    } else if (selectedIndex == 1) {
      return _completeScreen;
    } else {
      return _incompleteScreen;
    }
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> showCreateTodoDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController();
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        key: const Key('addDialogTextFormField'),
                        controller: _textEditingController,
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : "Invalid Task's name";
                        },
                        decoration: const InputDecoration(
                            hintText: "Enter Task's name"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Complete?"),
                          Checkbox(
                              key: const Key('addDialogStateCheckbox'),
                              value: isChecked,
                              onChanged: (checked) {
                                setState(() {
                                  isChecked = checked!;
                                });
                              })
                        ],
                      )
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final task = Task(_textEditingController.text, isChecked);
                      await dao.insertTask(task);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }
}
