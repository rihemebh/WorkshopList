import 'package:dbApp/DAO/dbHelper.dart';
import 'package:dbApp/models/Workshop_List.dart';
import 'package:flutter/material.dart';

class WorkshopListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buidDialog(BuildContext context, Workshop_List wk, bool isNew) {
    dbHelper db = dbHelper();
    if (!isNew) {
      txtName.text = wk.name;
      txtPriority.text = wk.priority.toString();
    }
    return AlertDialog(
      title: Text((isNew) ? "Add new Workshop" : "Edit the workshop"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: "Workshop Name"),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Workshop Priority (1-4)'),
            ),
            RaisedButton(
                child: Text('Save Workshop'),
                onPressed: () async {
                  await db.openDB();
                  wk.name = txtName.text;
                  wk.priority = int.parse(txtPriority.text);
                  db.insertWorkshop(wk);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
