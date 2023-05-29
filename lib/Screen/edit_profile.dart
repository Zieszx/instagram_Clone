import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: (){},
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.close),
            color: Colors.white,
            ),
        ],
        title: Text('Edits'),
      ),
      body: Center(
        child: Text('Edits Profile'),
      ),
    );
  }
}
