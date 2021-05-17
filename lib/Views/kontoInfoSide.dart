import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class KontoInfoSide extends StatelessWidget {
  KontoInfoSide({Key? key}) : super(key: key);

  final CollectionReference transactions =
      FirebaseFirestore.instance.collection('Transaction');
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          //Vis IBAN i title
          title: Text('detail page ' + Provider.of<CurrentKonto>(context).iban),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: transactions.snapshots(),
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
                    title: Text(snapshot.data?.docs[index]['beneficiary']),
                    subtitle: Text("${snapshot.data?.docs[index]['amount']}"),
                  );
                },
              );
            }),
      ),
    );
  }
}
