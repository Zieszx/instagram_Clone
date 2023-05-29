import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Screen/feed_screen.dart';
import 'package:instagram_clone/Screen/profile.dart';
import 'package:instagram_clone/Screen/upload_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_clone/Model/Post.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<FeedModel> _posts = [];
  Map<String, dynamic>? userData;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _fetchUserData();
  }

  Future<void> _fetchPosts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('posts').get();
      List<FeedModel> posts = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        List<dynamic> imageUrls = data['imageUrls']; // Retrieve as dynamic list
        List<String> convertedImageUrls =
            List<String>.from(imageUrls); // Convert to List<String>
        return FeedModel(
          username: data['username'],
          email: data['email'],
          caption: data['caption'],
          imageUrls: convertedImageUrls, // Use the converted list
        );
      }).toList();

      // Fetch user data for each post and add the profile image URL
      for (var post in posts) {
        QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: post.email)
            .limit(1)
            .get();
        if (userSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> userData = userSnapshot.docs.first.data();
          post.profileImageUrl = userData['photoURL'];
        }
      }

      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

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
        title: Text('Instagram Clone'),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          FeedModel post = _posts[index];

<<<<<<< Updated upstream
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        post.profileImageUrl ?? '', // Profile image URL
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      post.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 250, // Adjust the desired height of the container
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: post.imageUrls.map((imageUrl) {
                      return CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 5),
                ListTile(
                  subtitle: Text(post.caption),
                ),
              ],
=======
          return ListTile(
            title: Text(post['caption']),
            subtitle: Text(post['email']),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post['postURL']),
>>>>>>> Stashed changes
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userData?['displayName'] ?? ''),
              accountEmail: Text(widget.user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(userData?['photoURL'] ?? ''),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/');
              },
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
}
