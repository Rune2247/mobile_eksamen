import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './newTransaction.dart';
import '../dbService.dart';

// ignore: must_be_immutable
class KontoInfoSide extends StatelessWidget {
  final String iban;

  KontoInfoSide({Key? key, required this.iban}) : super(key: key);
  DBservice dBservice = new DBservice();

  @override
  Widget build(BuildContext context) {
    dBservice.getAccountBalance(iban);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          //Vis IBAN i title
          title: Text('detail page for iban:' + iban),
          actions: [
            FloatingActionButton(
                child: Icon(
                  Icons.add_circle,
                  color: Colors.black,
                  size: 30.0,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChangeNotifierProvider(
                        create: (_) => Status(),
                        child: NewTransactionPage(
                          iban: iban,
                        ));
                  }));
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: dBservice.transferStreamForAccount(iban),
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
              return Container(
                  child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (iban == snapshot.data!.docs[index]['iban']) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['beneficiary']),
                      subtitle:
                          Text(snapshot.data!.docs[index]['creationDate']),
                      trailing: Text("Kr. " +
                          snapshot.data!.docs[index]['amount'].toString()),
                    );
                  } else
                    return ListTile(
                      title: Text('Ikke din!'),
                    );
                },
              ));
            }),
      ),
    );
  }
}
