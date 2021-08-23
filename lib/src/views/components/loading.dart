import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String? loadingMessage;

  const Loading(this.loadingMessage);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   loadingMessage!,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 24,
          //   ),
          // ),
          // SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ],
      ),
    );
  }
}
