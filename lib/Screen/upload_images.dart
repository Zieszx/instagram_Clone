import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagesScreen extends StatefulWidget {
  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  List<File> _selectedImages = [];

  Future<void> _selectImages() async {
    final imagePicker = ImagePicker();
    final pickedImages = await imagePicker.pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        _selectedImages =
            pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
      });
    } else {
      print('No images selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: _selectedImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                final image = _selectedImages[index];
                return Image.file(image, fit: BoxFit.cover);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _selectImages,
              child: Text('Select Images'),
            ),
          ),
        ],
      ),
    );
  }
}
