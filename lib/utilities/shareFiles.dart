import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class ShareFile {
  Future<Uint8List> videoPathToUint8List(String path) async {
    Uint8List assetByteData = await File(path).readAsBytes();
    return assetByteData;
  }

  Future<ByteData> videoPathToFile(String path) async {
    final videoData = await rootBundle.load(path);
    return videoData;
  }

  void shareFile(file, String mimeType, String ext) async {
    try {
      print('sharing ${file.path}');
      final ByteData bytes = file.readAsBytesSync().buffer.asByteData();
      print('path to bytes');
      await WcFlutterShare.share(
          sharePopupTitle: 'share',
          fileName: 'googly_eyes.$ext',
          mimeType: mimeType,
          bytesOfFile: bytes.buffer.asUint8List());
    } catch (e) {
      print('error: $e');
    }
  }
}
