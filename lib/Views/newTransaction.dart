import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewTransactionPage extends StatelessWidget {
  final String iban;

  const NewTransactionPage({Key? key, required this.iban}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final companyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Her laver vi users!"),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Amount")),
                TextFormField(
                    controller: companyController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Company")),
                RaisedButton(
                  onPressed: () async {
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('Transaction');
                    await users.add({
                      'amount': amountController.text,
                      'beneficiary': companyController.text,
                      'creationDate': DateTime.now(),
                      'iban': iban
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Opret Transaction"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
