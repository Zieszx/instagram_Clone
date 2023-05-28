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

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _profileImage;

  Future<void> _signUp() async {
    try {
      final String accountName = _accountNameController.text.trim();
      final String username = _usernameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user details to Firebase Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'displayName': accountName,
        'username': username,
        'email': email,
        'photoURL': '',
      });

      // Upload profile image to Firebase Storage
      if (_profileImage != null) {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(userCredential.user!.uid + '.jpg');

        UploadTask uploadTask = storageRef.putFile(_profileImage!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String profileImageURL = await taskSnapshot.ref.getDownloadURL();

        // Update profile image URL in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({'photoURL': profileImageURL});
      }

      // Navigate to home screen after successful sign-up
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userCredential.user),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sign-Up Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _profileImage = File(pickedImage.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 40,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _accountNameController,
                  hintText: 'Account Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                MyButton(
                  text: 'Sign Up',
                  onTap: _signUp,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/signup'); // Navigate to sign-up page
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
