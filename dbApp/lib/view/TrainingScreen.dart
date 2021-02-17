import 'package:dbApp/DAO/dbHelper.dart';
import 'package:dbApp/models/Training.dart';
import 'package:dbApp/models/Workshop_List.dart';
import 'package:dbApp/view/TrainingDialog.dart';
import 'package:flutter/material.dart';
import 'package:dbApp/DAO/dbHelper.dart';

class TrainingScreen extends StatefulWidget {
  final Workshop_List workshop;
  TrainingScreen({Key key, this.workshop}) : super(key: key);

  @override
  _TrainingScreenState createState() => _TrainingScreenState(this.workshop);
}

class _TrainingScreenState extends State<TrainingScreen> {
  final Workshop_List workshop;
  final dbHelper db = dbHelper();
  TrainingDialog dialog = TrainingDialog();
  List<Training> trainings;
  _TrainingScreenState(this.workshop);
  Future<void> showTraining() async {
    await db.openDB();
    trainings = await db.getTraining(this.workshop.id);
    setState(() {
      trainings = trainings;
    });
  }

  @override
  void initState() {
    dialog = TrainingDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showTraining();
    return Scaffold(
      appBar: AppBar(
        title: Text(workshop.name),
      ),
      body: ListView.builder(
        itemCount: (trainings != null) ? trainings.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return Dismissible(
            key: Key(trainings[i].id.toString()),
            onDismissed: (direction) {
              db.deleteTraining(trainings[i]);
              setState(() {
                trainings.removeAt(i);
              });
            },
            child: Container(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog.buidDialog(
                          context, workshop, trainings[i], false));
                },
                child: ListTile(title: Text((trainings[i].name))),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog.buidDialog(
                  context,
                  workshop,
                  Training(
                      id: 0,
                      idWorkshop: workshop.id,
                      name: "",
                      trainer: "",
                      note: ""),
                  true));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
