import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final EdgeInsetsGeometry edgeInset;
  final double fontSize;

  const CustomElevatedButton({
    Key key,
    @required this.fontSize,
    @required this.edgeInset,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        onPrimary: Colors.white,
      ),
      child: Padding(
        padding: edgeInset,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, letterSpacing: 1.0),
        ),
      ),
    );
  }
}
