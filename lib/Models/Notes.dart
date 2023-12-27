class Notes {
  final int? id;
  final String title;
  final String note;
  final DateTime date;
  final String time;

    Notes(
      {this.id,
      required this.title,
      required this.note,
      required this.date,
      required this.time});

  Notes.fromMap(Map<String,dynamic> res):
      id=res['id'],
      title=res['title'],
      note=res['note'],
      date=DateTime.parse(res['date']),
      time=res['time'];

  Map<String,Object?> toMap(){
    return{
      'id' : id,
      'title' : title,
      'note' : note,
      'date' : date.toString(),
      'time' : time
    };
  }
}
