import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Views/forside.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      title: 'Bank App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: ChangeNotifierProvider(
        create: (_) => CurrentKonto(),
        child: MyApp(),
      )));
}

class CurrentKonto extends ChangeNotifier {
  String iban = 'unknown';
  void changeIban(String iban) {
    this.iban = iban;
    notifyListeners();
  }
}
