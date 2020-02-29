import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailPage extends StatelessWidget {
  final String filePath;

  ImageDetailPage(this.filePath) : assert(filePath != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: FileImage(File(filePath)),
    ));
  }
}
