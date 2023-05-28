import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Screen/profile.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _posts = [];
  Map<String, dynamic>? userData;

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
      List<Map<String, dynamic>> posts =
          snapshot.docs.map((doc) => doc.data()).toList();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram Clone'),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> post = _posts[index];

          return ListTile(
            title: Text(post['caption']),
            subtitle: Text(post['username']),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post['profileImageUrl']),
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
    );
  }
}
