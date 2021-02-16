import 'package:dbApp/DAO/dbHelper.dart';
import 'package:dbApp/models/Workshop_List.dart';
import 'package:dbApp/view/TrainingScreen.dart';
import 'package:dbApp/view/WorkshopListDialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: WKList()));
}

class WKList extends StatefulWidget {
  @override
  _WKListState createState() => _WKListState();
}

class _WKListState extends State<WKList> {
  dbHelper db = dbHelper();
  WorkshopListDialog dialog;
  List<Workshop_List> workshopsList;

  @override
  void initState() {
    dialog = WorkshopListDialog();
    super.initState();
  }

  Future showData() async {
    await db.openDB();
    workshopsList = await db.getList();
    // await db
    //  .updateWorkshop(Workshop_List(id: 1, name: "flutter7", priority: 3));

    setState(() {
      workshopsList = workshopsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite app'),
      ),
      body: ListView.builder(
          itemCount: (workshopsList != null) ? workshopsList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrainingScreen(
                              workshop: workshopsList[index],
                            )));
              },
              child: Dismissible(
                key: Key(workshopsList[index].name),
                onDismissed: (direction) {
                  // String strName = workshopsList[index].name;
                  db.deleteWorkshop(workshopsList[index]);
                  setState(() {
                    workshopsList.removeAt(index);
                  });
                },
                child: ListTile(
                  title: Column(
                    children: [
                      Text((workshopsList[index].name)),
                      RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    dialog.buidDialog(
                                        context, workshopsList[index], false));
                          },
                          child: Icon(Icons.update)),
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog.buidDialog(
                  context, Workshop_List(id: 0, name: "", priority: 0), true));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
