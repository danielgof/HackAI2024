import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
