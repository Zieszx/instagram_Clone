import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone/Screen/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/components/my_button.dart';
import 'package:instagram_clone/components/my_textfield.dart';

class UploadImagesScreen extends StatefulWidget {
  final User? user;
  UploadImagesScreen(this.user);

  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _captionController = TextEditingController();
  List<File> _selectedImages = [];
  Map<String, dynamic>? userData;
  String email = "";

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: widget.user?.email)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        userData = snapshot.docs.first.data();
        setState(() {});
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _selectImages() async {
    try {
      final String caption = _captionController.text.trim();
      final String email = userData?["email"];
      final String username = userData?["username"];
      final imagePicker = ImagePicker();
      final pickedImages = await imagePicker.pickMultiImage();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user!.uid)
          .set({
        'username': username,
        'email': email,
        'caption': caption,
        'photoURL': '',
      });

      if (pickedImages != null) {
        setState(() {
          _selectedImages = pickedImages
              .map((pickedImage) => File(pickedImage.path))
              .toList();
        });
      } else {
        print('No images selected.');
      }
    } catch (e) {
      print('Error selecting images: $e');
    }
  }

  Future<void> _uploadImagesAndNavigate() async {
    try {
      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (File imageFile in _selectedImages) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().toIso8601String()}');
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Save image URLs and caption to Firestore
      final String caption = _captionController.text.trim();
      await FirebaseFirestore.instance.collection('posts').doc().set({
        'username': userData?['username'],
        'email': userData?['email'],
        'caption': caption,
        'photoURLs': imageUrls,
      });

      // Navigate to home screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(widget.user)),
      );
    } catch (e) {
      print('Error uploading images and navigating: $e');
    }
  }

  void initState() {
    super.initState();
    Firebase.initializeApp();
    _fetchUserData();
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
          MyTextField(
            controller: _captionController,
            hintText: 'Caption',
            obscureText: false,
          ),
          ElevatedButton(
            onPressed: _uploadImagesAndNavigate,
            child: Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Back'),
          ),
        ],
      ),
    );
  }
}
