import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Screen/home_screen.dart';
import 'package:instagram_clone/Screen/upload_images.dart';
import 'package:instagram_clone/Screen/edit_profile.dart';

class FeedScreen extends StatefulWidget {
  final User? user;

  FeedScreen(this.user);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Map<String, dynamic>? userData;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
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

  void _onBottomNavigationBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Home screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(widget.user),
          ),
        );
        break;
      case 1:
        // Upload photos screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadImagesScreen(widget.user),
          ),
        );
        break;
      case 2:
        // Profile screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedScreen(widget.user),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                userData?['photoUrl'] ?? '',
              ),
              radius: 40,
            ),
            SizedBox(height: 16),
            Text(
              userData?['displayName'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.user?.email ?? '',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatColumn(userData?['postLen'] ?? 0, 'posts'),
                buildStatColumn(userData?['followers'] ?? 0, 'followers'),
                buildStatColumn(userData?['following'] ?? 0, 'following'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ),
                );
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.lightGreen[50],
        onTap: _onBottomNavigationBarItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_rounded),
            label: 'Upload Photos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
