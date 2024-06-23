import 'package:flutter/material.dart';

bool dialogPresentOnScreen = false;

showLoaderDialog(context) {
  dialogPresentOnScreen = true;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: WillPopScope(
          onWillPop: () async {
            dialogPresentOnScreen = false;
            return true;
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}
