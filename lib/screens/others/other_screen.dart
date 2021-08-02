import 'package:flutter/material.dart';

class OtherScreen extends StatelessWidget {
  static const String routeName = '/others';
  const OtherScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Others'),
    );
  }
}
