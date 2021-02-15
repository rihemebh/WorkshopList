// ignore: camel_case_types
class Workshop_List {
  int id;
  String name;
  int priority;

  Workshop_List({this.id, this.name, this.priority});

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'Name': name,
      'Priority': priority,
    };
  }
}
