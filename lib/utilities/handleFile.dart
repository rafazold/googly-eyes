import 'dart:io';
import 'package:flutter/material.dart';

Future getImageDetails(imageFile) async {
  var imageDecoded = await decodeImageFromList(imageFile.readAsBytesSync());
  AssetDetails imageDetails =
      AssetDetails(imageFile, imageDecoded.width, imageDecoded.height);

  return imageDetails;
}

class AssetDetails {
  String path;
  String type;
  int width;
  int height;
  String ext;
  String mimeType;
  File file;

  AssetDetails(File file, int width, int height) {
    this.file = file;
    this.width = width;
    this.height = height;
    this.path = file.path;
  }
}
