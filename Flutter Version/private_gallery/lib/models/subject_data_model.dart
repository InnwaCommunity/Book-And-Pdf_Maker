
import 'package:private_gallery/config/constant.dart';

class Subject {
   int? id;
   String subjectName;
   DateTime createDate;
   String pdfFile;

  Subject({
    this.id,
    required this.subjectName,
    required this.createDate,
    required this.pdfFile
  });

  Map<String, dynamic> toMap() {
    return {
      Constants.subjectName: subjectName,
      Constants.subjectCreatedate: createDate.toUtc().toIso8601String(), // Convert DateTime to string
      Constants.pdfFile:pdfFile
    };
  }
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map[Constants.subjectId],
      subjectName: map[Constants.subjectName],
      createDate: DateTime.parse(map[Constants.subjectCreatedate]),
      pdfFile: map[Constants.pdfFile]
    );
  }
}