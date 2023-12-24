
import 'dart:io';

import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
Future<XFile> rotateAndSaveImage(XFile picture) async {
  final img.Image capturedImage = img.decodeImage(await picture.readAsBytes())!;
  // final img.Image rotatedImage = img.flip(capturedImage, );
  final img.Image rotatedImage=img.flip(capturedImage, direction: FlipDirection.horizontal);

  final Directory tempDir = await getTemporaryDirectory();
  final String tempPath =
      '${tempDir.path}/rotated_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  await File(tempPath).writeAsBytes(img.encodeJpg(rotatedImage));

  return XFile(tempPath);
}


Future<Directory> getAppDirectory() async {
  Directory appDocumentsDirectory = await getApplicationSupportDirectory();
  if (Platform.isIOS) {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
  }
  return appDocumentsDirectory;
}