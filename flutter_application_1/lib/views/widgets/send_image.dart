// ignore: must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_servrices.dart';
import 'package:image_picker/image_picker.dart';

class SendImage extends StatefulWidget {
  String receiverId;
  String senderId;
  String chrId;
  SendImage(
      {super.key,
      required this.chrId,
      required this.receiverId,
      required this.senderId,});

  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  final firebaseServices = FirebaseServices();
  File? imageFile;

  Future<void> awaitUntillSend() async {
    await firebaseServices.startImageMessage(
        widget.receiverId, widget.senderId, widget.chrId, imageFile!);
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Send Image"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose Image",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: openCamera,
                label: const Text("Camera"),
                icon: const Icon(Icons.camera),
              ),
              TextButton.icon(
                onPressed: openGallery,
                label: const Text("Gallery"),
                icon: const Icon(Icons.image),
              ),
            ],
          ),
          if (imageFile != null)
            SizedBox(
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
            )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            if (imageFile != null) {
              Navigator.of(context).pop();
              awaitUntillSend();
            }
          },
          child: const Text("Send"),
        ),
      ],
    );
  }
}
