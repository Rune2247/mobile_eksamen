import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dbService.dart';
import '../main.dart';
import 'createKonto.dart';
import 'kontoInfoSide.dart';

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
    DBservice dBservice = new DBservice();

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
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.black,
                  size: 30.0,
                ),
              )
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: dBservice.accountStream(),
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
                      trailing: FutureBuilder(
                        future: dBservice.getAccountBalance(
                            snapshot.data!.docs[index]['iban']),
                        builder: (context, snapshot) {
                          return Text('Kr. ' + snapshot.data.toString());
                        },
                      ),
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
