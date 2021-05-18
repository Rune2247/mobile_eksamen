import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Views/kontoInfoSide.dart';
import 'Views/createKonto.dart';
import 'package:provider/provider.dart';

import 'Models/Account.dart';
import 'Models/Kind.dart';
import 'Models/Transaction.dart';

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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Ops, Der er sket en fejl med FireStore");
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            child: KontoList(),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Text("Loading! please wait :)");
      },
    );
  }
}

class KontoList extends StatelessWidget {
  const KontoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference konti =
        FirebaseFirestore.instance.collection('Account');

    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Bank oversigt"),
            actions: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CreateKonto();
                  }));
                },
                child: (Text('Indsæt icon eller billede her')),
              )
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: konti.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Der gik noget galt!');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['name']),
                      subtitle: Text(snapshot.data!.docs[index]['iban']),
                      onTap: () {
                        Provider.of<CurrentKonto>(context, listen: false)
                            .changeIban(snapshot.data!.docs[index]['iban']);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return KontoInfoSide(
                              iban: snapshot.data!.docs[index]['iban']);
                        }));
                      },
                    );
                  });
            },
          )),
    );
  }
}

class CurrentKonto extends ChangeNotifier {
  String iban = 'unknown';
  void changeIban(String iban) {
    this.iban = iban;
    notifyListeners();
  }
}
