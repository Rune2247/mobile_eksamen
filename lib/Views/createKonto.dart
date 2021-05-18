import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_eksamen_opg/Models/Account.dart';
import 'package:mobile_eksamen_opg/dbService.dart';

class CreateKonto extends StatelessWidget {
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
            child: CreateForm(),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Text("Loading! please wait :)");
      },
    );
  }
}

class CreateForm extends StatefulWidget {
  CreateForm({Key? key}) : super(key: key);

  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DBservice dBservice = new DBservice();

    String _kind = 'Andet';

    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<QuerySnapshot>(
            stream: dBservice.kindStream(),
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
              return Form(
                  key: _formKey,
                  child: Column(children: [
                    //
                    Container(
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                      ),
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: FloatingActionButton(
                          child: Text('Create Konto'),
                          onPressed: () async {
                            CollectionReference kindList = FirebaseFirestore
                                .instance
                                .collection('Account');
                            int number = await dBservice.newAcountNumber();
                            await kindList.add({
                              'name': nameController.text,
                              'kind': _kind,
                              'iban': number.toString(),
                            });
                            Navigator.pop(context);
                          },
                        )),
                  ]));
            }),
      ),
    );
  }
}
