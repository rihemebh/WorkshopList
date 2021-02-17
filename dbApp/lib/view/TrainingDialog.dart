import 'package:dbApp/DAO/dbHelper.dart';
import 'package:dbApp/models/Training.dart';
import 'package:dbApp/models/Workshop_List.dart';
import 'package:flutter/material.dart';

class TrainingDialog {
  final txtName = TextEditingController();
  final txtTrainer = TextEditingController();
  final txtNote = TextEditingController();

  Widget buidDialog(
      BuildContext context, Workshop_List wk, Training tr, bool isNew) {
    dbHelper db = dbHelper();
    if (!isNew) {
      txtName.text = tr.name;
      txtTrainer.text = tr.trainer.toString();
      txtNote.text = tr.note;
    }
    return AlertDialog(
      title: Text((isNew) ? "Add new training" : "Edit the training"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: "Training Name"),
            ),
            TextField(
              controller: txtTrainer,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Trainer'),
            ),
            TextField(
              controller: txtNote,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Notes'),
            ),
            RaisedButton(
                child: Text('Save Training'),
                onPressed: () async {
                  await db.openDB();
                  tr.name = txtName.text;
                  tr.trainer = txtTrainer.text;
                  tr.note = txtNote.text;
                  if (isNew) {
                    db.insertTraining(tr);
                  } else {
                    db.updateTraining(tr);
                  }
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
