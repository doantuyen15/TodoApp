import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// import 'package:untitled/main.dart' as app;
import 'package:untitled/main.dart';

void main(){
  group('App Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    //Test app main()
    testWidgets("Full app test", (tester) async {
      await tester.pumpWidget(TodoApp());

      // test first screen

      //test add task dialog
      final buttonAddDialog = find.byKey(const Key('buttonAddDialog'));
      final addDialogTextFormField = find.byKey(const Key('addDialogTextFormField'));
      final addDialogStateCheckbox = find.byKey(const Key('addDialogStateCheckbox'));
      const String taskName_test = 'Task1';
      // const String taskState_test = 'true';

      await tester.tap(buttonAddDialog);
      await tester.pump();

      expect(tester.getSemantics(addDialogStateCheckbox), matchesSemantics(
        hasTapAction: true,
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true
      ));
      await tester.enterText(addDialogTextFormField, taskName_test);
      await tester.tap(addDialogStateCheckbox);


    });
  });
}