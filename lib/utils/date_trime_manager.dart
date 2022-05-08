class DateTimeManager{
  static String getDate(){
    var dateTime=DateTime.now();
    return '${dateTime.day} - ${dateTime.month} - ${dateTime.year}  ${dateTime.hour}:${dateTime.minute}:${dateTime.minute}';
  }
}