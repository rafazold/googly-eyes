import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImage {
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    print(pickedFile.path);
    return pickedFile;
  }

  Future getPicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return pickedFile;
  }

  Widget displaySelectedFile(File file) {
    return new SizedBox(
      height: 200.0,
      width: 300.0,
      //child: new Card(child: new Text(''+galleryFile.toString())),
      //child: new Image.file(galleryFile),
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(file),
    );
  }
}
