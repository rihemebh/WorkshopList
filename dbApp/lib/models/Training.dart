class Training {
  int id;
  String name;
  String trainer;
  String note;
  int idWorkshop;

  Training({this.id,this.idWorkshop, this.name, this.trainer, this.note});

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'idWorkshop': idWorkshop,
      'name': name,
      'trainer': trainer,
      'note': note,
    };
  }
}
