import 'package:private_gallery/config/constant.dart';

class PhotoData {
  int? photoid;
  String photoName;
  String photoPath;
  DateTime photoCreateDate;
  int photoSize;

  PhotoData({
    this.photoid,
    required this.photoName,
    required this.photoPath,
    required this.photoCreateDate,
    required this.photoSize,
  });

  // Convert a Note object into a Map
  Map<String, dynamic> toMap() {
    return {
      Constants.photoName: photoName,
      Constants.photoPath: photoPath,
      Constants.photoCreateDate: photoCreateDate.toUtc().toIso8601String(), // Convert DateTime to string
      Constants.photoSize: photoSize,
    };
  }

  // Convert a Map object into a Note
  factory PhotoData.fromMap(Map<String, dynamic> map) {
    return PhotoData(
      photoid: map[Constants.photoid],
      photoName: map[Constants.photoName],
      photoPath: map[Constants.photoPath],
      photoCreateDate: DateTime.parse(map[Constants.photoCreateDate]),
      photoSize: map[Constants.photoSize],
    );
  }
}