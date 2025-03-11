import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

String getImage(File? imageFile) {
  if (imageFile == null) return '';
  String base64 = base64Encode(imageFile.readAsBytesSync());
  return base64;
}

Uint8List getImageFromBase64(String image) {
  return base64Decode(image);
}

Widget imageWidget(String image) {
  return image.startsWith('https://')
      ? Image.network(image)
      : Image.memory(getImageFromBase64(image));
}

Widget imageWidgetWithSize(String image, double width, double height) {
  return image.startsWith('https://')
      ? Image.network(image, height: height, width: width)
      : Image.memory(getImageFromBase64(image), height: height, width: width);
}
