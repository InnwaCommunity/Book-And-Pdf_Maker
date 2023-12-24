import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_gallery/models/photo_detail_model.dart';
import 'package:private_gallery/module/photodetail/bloc/showphotodetailprovider_bloc.dart';

class PhotoDetail extends StatefulWidget {
  final ViewPhotoDetail viewPhotoDetail;
  const PhotoDetail({required this.viewPhotoDetail, super.key});

  @override
  State<PhotoDetail> createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {
  File? selectedPhoto;
  List<File> allPhotos = [];
  bool onTap = false;
  @override
  void initState() {
    super.initState();
    selectedPhoto = widget.viewPhotoDetail.selectedPhoto;
    allPhotos = widget.viewPhotoDetail.allPhoto;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowphotodetailproviderBloc,
        ShowphotodetailproviderState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: onTap ? Colors.transparent : null,
            appBar: AppBar(
                // backgroundColor: Colors.transparent,
                ),
            bottomNavigationBar: onTap
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: allPhotos.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              selectedPhoto = allPhotos[index];
                              BlocProvider.of<ShowphotodetailproviderBloc>(
                                      context)
                                  .add(StateChangeEvent());
                            },
                            child: 
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.file(allPhotos[index], fit: BoxFit.contain,width: double.infinity,),
                                // Image.file(
                                //   allPhotos[index],
                                //   fit: BoxFit.cover,
                                //   width: double.infinity,
                                //   filterQuality: FilterQuality.high,
                                // ),
                              ),
                            ),
                          );
                        })),
            body: GestureDetector(
              onTap: () {
                onTap = !onTap;
                BlocProvider.of<ShowphotodetailproviderBloc>(context)
                    .add(StateChangeEvent());
              },
              onDoubleTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ext) {
                    double horLength = 140;
                    Future.delayed(const Duration(milliseconds: 500), () {
                      horLength = 140.0;
                      // BlocProvider.of<ShowdialoganimationBloc>(context)
                      //     .add(Changeeventdialog(horlength: horLength));
                    });
                    return Dialog(
                      alignment: Alignment.center,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: horLength,
                        vertical: 24.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete_forever),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(selectedPhoto ?? widget.viewPhotoDetail.selectedPhoto, fit: BoxFit.contain,width: double.infinity,),
                  // Image.file(
                  //   selectedPhoto ?? widget.viewPhotoDetail.selectedPhoto,
                  //   fit: BoxFit.contain,
                  //   width: double.infinity,
                  // ),
                ),
              ),
            ));
      },
    );
  }
}
