import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewPage extends StatefulWidget {
  final String pdfpath;
  const PdfViewPage({required this.pdfpath, super.key});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  // late PDFViewController _pdfViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PDFView(
  filePath: widget.pdfpath,
  enableSwipe: true,
  swipeHorizontal: false,
  autoSpacing: false,
  pageFling: false,
  defaultPage: 0,
  password: 'Nyein',
  onRender: (_) {
    // setState(() {
    //   pages = _pages;
    //   isReady = true;
    // });
  },
  onError: (error) {
    // print(error.toString());
  },
  onPageError: (page, error) {
    // print('$page: ${error.toString()}');
  },
  onViewCreated: (PDFViewController pdfViewController) {
    // _pdfViewController.complete(pdfViewController);
  },
  // onPageChanged: (int page, int total) {
  //   // print('page change: $page/$total');
  // },
),
    );
  }
}