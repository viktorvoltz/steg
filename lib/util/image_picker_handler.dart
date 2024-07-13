import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_steganograph/flutter_steganograph.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as dImage;

class ImagePickerHandler {
  static Future<Uint8List?> getImage() async {
    String input = "super secret message";
    final steganography = Steganograph();
    String? path = await imagePath();
    late dImage.Image coverImageText;
    if (path != null) {
      if (path.endsWith('.png')) {
        coverImageText = dImage.decodePng(File(path).readAsBytesSync())!;
      } else {
        coverImageText = dImage.decodeJpg(File(path).readAsBytesSync())!;
      }
      final embeddedTextImage = steganography.embedText(
        image: coverImageText,
        text: input,
      );

      steganography.extractText(
        image: dImage.decodePng(embeddedTextImage)!,
        length: input.length,
      );

      var bytes = embeddedTextImage;
      return bytes;
    }
  }

  static Future<({Uint8List? embeddedBytes, Uint8List? extractedBytes})>
      getMultipleImage() async {
    final steganography = Steganograph();
    ({String? coverPath, String? secretPath}) path = await multipleImagePath();
    if (path.coverPath != null && path.secretPath != null) {
      final coverImage =
          dImage.decodeImage(File(path.coverPath!).readAsBytesSync())!;
      final secretImage =
          dImage.decodeImage(File(path.secretPath!).readAsBytesSync())!;
      final embeddedImageCover = steganography.embedImage(
        coverImage: coverImage,
        secretImage: secretImage,
      );
      final embeddedBytes = embeddedImageCover;
      final extractedSecretImage = steganography.extractImage(
        embeddedImage: dImage.decodePng(embeddedImageCover)!,
        secretWidth: secretImage.width,
        secretHeight: secretImage.height,
      );
      final extractedBytes = extractedSecretImage;

      return (embeddedBytes: embeddedBytes, extractedBytes: extractedBytes);
    } else {
      return (embeddedBytes: null, extractedBytes: null);
    }
  }

  static Future<String?> imagePath() async {
    String? path;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      path = image.path;
    }

    return path;
  }

  static Future<({String? coverPath, String? secretPath})>
      multipleImagePath() async {
    String? path1;
    String? path2;
    final ImagePicker picker = ImagePicker();
    final List<XFile?> image =
        await picker.pickMultiImage(limit: 2, maxHeight: 200, maxWidth: 200);

    if (image.isNotEmpty) {
      path1 = image[0]!.path;
      path2 = image[1]!.path;
    } else {
      path1 = null;
      path2 = null;
    }

    return (coverPath: path1, secretPath: path2);
  }
}
