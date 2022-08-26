import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;

  const EmptyContent({
    Key? key,
    this.title = 'Nothing here',
    this.message = 'Add a new item to get started',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(  // center horizontally
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // center vertically
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 32.0, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
