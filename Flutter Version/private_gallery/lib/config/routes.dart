import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_gallery/SqLHelper/note_create.dart';
import 'package:private_gallery/models/edit_photo_model.dart';
import 'package:private_gallery/models/photo_detail_model.dart';
import 'package:private_gallery/models/subject_data_model.dart';
import 'package:private_gallery/module/camera_view/camera_view_page.dart';
import 'package:private_gallery/module/edit_photo/bloc/edit_photo_state_provider_bloc.dart';
import 'package:private_gallery/module/edit_photo/edit_photo_view.dart';
import 'package:private_gallery/module/home/bloc/home_screen_provider_bloc.dart';
import 'package:private_gallery/module/home/bloc/showdialoganimation_bloc.dart';
import 'package:private_gallery/module/home/home_screen.dart';
import 'package:private_gallery/module/lock/lock_screen.dart';
import 'package:private_gallery/module/pdf_view_page/bloc/pdf_view_provider_bloc.dart';
import 'package:private_gallery/module/pdf_view_page/pdf_view_page.dart';
import 'package:private_gallery/module/photodetail/bloc/showphotodetailprovider_bloc.dart';
import 'package:private_gallery/module/photodetail/showphotodetail.dart';
import 'package:private_gallery/module/write_note/bloc/write_note_state_manangement_bloc.dart';
import 'package:private_gallery/module/write_note/write_note.dart';

class Routes {
  static const lock = '/';
  // static const pdf='/';
  static const home = 'home';
  static const cameraview='cameraview';
  static const camerapreview='camerapreview';
  static const writenote = 'writenote';
  static const photoDetail = 'photoDetail';
  static const editPhoto = 'edit_photo';
  static const pdfView = 'pdfView';

  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    final argument = settings.arguments;

    switch (settings.name) {
      case '/':
        return makeRoute(const LockScreen(), settings);
      // return makeRoute(const PdfTesting(), settings);
      case 'home':
        return makeRoute(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ShowdialoganimationBloc(),
                ),
                BlocProvider(
                  create: (context) =>
                      HomeScreenProviderBloc(DatabaseHelper.instance),
                ),
              ],
              child: const MyHomePage(),
            ),
            settings);

      case 'cameraview':
       return makeRoute(const CameraViewPage(), settings);
      case 'writenote':
        return makeRoute(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      WriteNoteStateManangementBloc(DatabaseHelper.instance),
                ),
                BlocProvider(
                  create: (context) => HomeScreenProviderBloc(DatabaseHelper.instance),
                ),
              ],
              child: WriteNote(
                subject: argument as Subject,
              ),
            ),
            settings);

      case 'photoDetail':
        return makeRoute(
            BlocProvider(
              create: (context) => ShowphotodetailproviderBloc(),
              child: PhotoDetail(
                viewPhotoDetail: argument as ViewPhotoDetail,
              ),
            ),
            settings);

      case 'edit_photo':
        return makeRoute(
            BlocProvider(
              create: (context) => EditPhotoStateProviderBloc(),
              child: EditPhotoView(editPhoto: argument as EditPhoto),
            ),
            settings);

      case 'pdfView':
        return makeRoute(
            BlocProvider(
              create: (context) => PdfViewProviderBloc(),
              child: PdfViewPage(
                pdfpath: argument as String,
              ),
            ),
            settings);
    }
    return null;
  }
}

Route? makeRoute(Widget widget, RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) {
      return widget;
    },
    settings: settings,
  );
}
