import 'dart:ui';

import 'package:flutter/material.dart';

Widget entryBar({
  Widget? child,
  String? text,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.all(0),
    minLeadingWidth: 60,
    horizontalTitleGap: 7,
    leading: Text(
      '$text :',
      style: const TextStyle(
        height: 1.7,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    title: child,
  );
}

showSnackBar<Widget>(
  BuildContext context,
  String message,
) {
  if (message.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 5000),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}

InputDecoration kDecoration = const InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.all(8),
  hintStyle: TextStyle(fontSize: 15),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff999999), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff999999), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
  ),
);

class Spinner extends StatelessWidget {
  const Spinner({
    Key? key,
    required this.spinning,
    this.child = const SizedBox(),
  }) : super(key: key);

  final bool spinning;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Visibility(
          visible: spinning,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Image.asset(
                  'assets/loader.gif',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
