import 'dart:async';

import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:flutter/material.dart';

class NetworkImageHandlingException extends StatelessWidget {
  final String url;
  final String? placeHolder;
  final Widget? stackImage;

  NetworkImageHandlingException(this.url, {this.placeHolder, this.stackImage});

  Future<bool> cacheImage(String url, BuildContext context) async {
    bool hasNoError = true;
    var output = Completer<bool>();
    precacheImage(
      NetworkImage(url),
      context,
      onError: (e, stackTrace) => hasNoError = false,
    ).then((_) => output.complete(hasNoError));
    return output.future;
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: cacheImage(url, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.hasError) {
          return Container(
            // height: 80.0,
            decoration: BoxDecoration(color: shimmerColor),
            child: placeHolder != null ? ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Stack(
                children: [
                  Image.asset(
                    placeHolder!,
                    fit: BoxFit.cover,
                  ),
                  stackImage??Container()
                ],
              ),
            ):
                Center(
                  child: Text(
                    'Error',
                  ),
          ));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
                decoration: BoxDecoration(color: shimmerColor),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 50,
                      minHeight: 20,
                    ),
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primaryColor),
                    )),
              ),
            ),
          );
        }
        if (snapshot.data == false) {
          return Container(
            // height: 80.0,
            decoration: BoxDecoration(color: shimmerColor),
            child: Center(
              child: placeHolder != null
                  ? Image.asset(
                      placeHolder!,
                      fit: BoxFit.cover,
                    )
                  : Text(
                      'Error',
                      style: TextStyle(fontSize: 10.0),
                    ),
            ),
          );
        }

        return stackImage == null
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                      stackImage ?? Container()
                    ],
                  ),
                ),
              );
      },
    );
  }
}
