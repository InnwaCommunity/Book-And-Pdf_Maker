import 'package:private_gallery/config/constant.dart';

class Note {
  int? id;
  int subjectId;
  String title;
  String notes;
  String createDate;
  DateTime? alarmTime;

  Note({
    this.id,
    required this.subjectId,
    required this.title,
    required this.notes,
    required this.createDate,
    this.alarmTime,
  });

  // Convert a Note object into a Map
  Map<String, dynamic> toMap() {
    return {
      Constants.subjectId: subjectId,
      Constants.columnTitle: title,
      Constants.columnNotes: notes,
      Constants.columnCreateDate: createDate,
       Constants.columnAlarmTime: alarmTime?.toUtc().toIso8601String(), // Convert DateTime to string
    
    };
  }

  // Convert a Map object into a Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map[Constants.columnId],
      subjectId: map[Constants.subjectId],
      title: map[Constants.columnTitle],
      notes: map[Constants.columnNotes],
      createDate: map[Constants.columnCreateDate],
      alarmTime: map[Constants.columnAlarmTime] != null
          ? DateTime.parse(map[Constants.columnAlarmTime]) // Parse string to DateTime if not null
          : null,
    );
  }
}