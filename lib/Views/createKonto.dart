import 'package:flutter/material.dart';

class CreateKonto extends StatefulWidget {
  CreateKonto({Key? key}) : super(key: key);

  @override
  _CreateKontoState createState() => _CreateKontoState();
}

class _CreateKontoState extends State<CreateKonto> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create page'),
        ),
        body: Text('Body'),
      ),
    );
  }
}
