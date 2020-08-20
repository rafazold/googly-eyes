import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class HandleImage {
  Future cropImage(String imagePath) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    // if (croppedFile != null) {
    //   return croppedFile;
    // }
    return croppedFile.path;
  }

  Future<String> copyAnimationFromAssetsToTemp(
      String assetName, String outputName) async {
    Directory tempDir = await getTemporaryDirectory();
    final ByteData assetByteData = await rootBundle.load(assetName);
    print('asset $assetName');
    final String fullTemporaryPath = tempDir.path + outputName;
    // setState(() {
    //   tempAnimatedImgOut = fullTemporaryPath;
    // });
    print('copyAnimationFromAssetsToTemp');
    List<int> bytes = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);
    // List<int> bytes = File(assetName).readAsBytesSync();
    print('copyAnimationFromAssetsToTemp');
    var anim = decodeAnimation(bytes);
    var png = encodePngAnimation(anim);
    File(fullTemporaryPath)..writeAsBytesSync(png);
    return fullTemporaryPath;
  }
}
