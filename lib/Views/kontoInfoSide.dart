import 'package:flutter/material.dart';

class KontoInfoSide extends StatelessWidget {
  const KontoInfoSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('detail page'),
        ),
        body: Text('Body!'),
      ),
    );
  }
}
