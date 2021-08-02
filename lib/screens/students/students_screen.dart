import 'package:flutter/material.dart';

class StudentsScreen extends StatelessWidget {
  static const String routeName = '/students';
  const StudentsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Students'),
    );
  }
}
