class Note{
  int? noteId;
  String? note;
  String? date;
  Note({this.noteId,required this.note,required this.date});
  Map<String,dynamic> toMap()=>{
    'noteText':this.note,
    'noteDate':this.date
  };
  Note.fromMap(Map<String,dynamic> mapNote){
    this.noteId=mapNote['noteId'];
    this.note=mapNote['noteText'];
    this.date=mapNote['noteDate'];

  }
}