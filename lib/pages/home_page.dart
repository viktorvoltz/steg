import 'dart:typed_data';

import 'package:enigma/util/image_picker_handler.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? imageEncrypted;
  Uint8List? coverEncryptedImage;
  Uint8List? secretEncryptedImage;

  ({Uint8List? embeddedBytes, Uint8List? extractedBytes})? bulkImage;

  void setImage() async {
    // imageEncrypted = await ImagePickerHandler.getImage();
    ({Uint8List? embeddedBytes, Uint8List? extractedBytes}) bulkImage =
        await ImagePickerHandler.getMultipleImage();
    coverEncryptedImage = bulkImage.embeddedBytes;
    secretEncryptedImage = bulkImage.extractedBytes;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // imageEncrypted == null ? Container() : Image.memory(imageEncrypted!),
          secretEncryptedImage == null
              ? const Text("null")
              : Column(
                  children: [
                    SizedBox(child: Image.memory(coverEncryptedImage!)),
                    const SizedBox(height: 10),
                    SizedBox(child: Image.memory(secretEncryptedImage!)),
                  ],
                ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setImage();
              },
              child: const Text("pick image"),
            ),
          ),
        ],
      ),
    );
  }
}
