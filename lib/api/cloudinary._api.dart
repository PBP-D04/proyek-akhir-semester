import 'dart:typed_data';
import 'dart:typed_data';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:uuid/v4.dart';

//final cloudinary = Cloudinary.signedConfig(
 // apiKey: '953851444543989',
//  apiSecret: 'ym3dytXciaZRw8HThsrmtSBwPiY',
 // cloudName: 'dskdlrjg6',
//);
final cloudinary = CloudinaryPublic('dskdlrjg6', 'ml_default', cache: false);

Future<String?> uploadImageToCloudinaryPublic(File image) async{
  try {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
    );

    print(response.secureUrl);
    return  response.secureUrl;
  } on CloudinaryException catch (e) {
    print(e.message);
    print(e.request);
    return null;
  }
}

Future<String?> uploadImageToCloudinaryPublicFromByteData(Uint8List imageData) async {
  var uuid = Uuid();
  String identifier = uuid.v4();
  try {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromBytesData(imageData, identifier: identifier, resourceType: CloudinaryResourceType.Image),
    );

    print(response.secureUrl);
    return response.secureUrl;
  } on CloudinaryException catch (e) {
    print(e.message);
    print(e.request);
    return null;
  }
}