import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_gallery/module/camera_view/bloc/camera_view_page_bloc.dart';

class CameraViewPage extends StatefulWidget {

 const CameraViewPage({super.key});

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {

  CameraController? controller;
  int pointers = 0;
  @override
  Widget build(BuildContext context) {
  // 
    return BlocBuilder<CameraViewPageBloc, CameraViewPageState>(
      builder: (context, state) {
    
     return Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  // color:
                  //     controller != null && controller!.value.isRecordingVideo
                  //         ? Colors.redAccent
                  //         : Colors.grey,
                  width: 3.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
          ),
          // _captureControlRowWidget(),
          // _modeControlRowWidget(),
          // Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: Row(
          //     children: <Widget>[
          //       _cameraTogglesRowWidget(),
          //       _thumbnailWidget(),
          //     ],
          //   ),
          // ),
        ],
      );
      },
    );
  }

  Widget _cameraPreviewWidget(){
    final CameraController? cameraController = controller;
       if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => pointers++,
        onPointerUp: (_) => pointers--,
        child: CameraPreview(
          cameraController,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              // onScaleStart: _handleScaleStart,
              // onScaleUpdate: _handleScaleUpdate,
              // onTapDown: (TapDownDetails details) =>
              //     onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }
}
