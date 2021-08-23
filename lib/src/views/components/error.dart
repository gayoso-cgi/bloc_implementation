import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String? errorMessage;
  final Function? onRetryPressed;

  const Error({this.errorMessage, this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: primaryColor,
            child: Text(
              'Retry',
            ),
            onPressed: () => onRetryPressed!(),
          )
        ],
      ),
    );
  }
}
