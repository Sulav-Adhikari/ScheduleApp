class Notes {
  final int? id;
  final String title;
  final String note;
  final DateTime date;
  final String time;
  final bool isCompleted;

    Notes(
      {this.id,
      required this.title,
      required this.note,
      required this.date,
      required this.time,
      required this.isCompleted});

  Notes.fromMap(Map<String,dynamic> res):
      id=res['id'],
      title=res['title'],
      note=res['note'],
      date=DateTime.parse(res['date']),
      time=res['time'],
      isCompleted=bool.parse(res['isCompleted']);

  Map<String,Object?> toMap(){
    return{
      'id' : id,
      'title' : title,
      'note' : note,
      'date' : date.toString(),
      'time' : time,
      'isCompleted': isCompleted.toString()
    };
  }
}
