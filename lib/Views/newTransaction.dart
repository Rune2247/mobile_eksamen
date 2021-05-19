import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_eksamen_opg/dbService.dart';
import 'package:provider/provider.dart';

class NewTransactionPage extends StatelessWidget {
  final String iban;

  const NewTransactionPage({Key? key, required this.iban}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final companyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    DBservice dBservice = new DBservice();

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Transaction"),
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
                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: () async {
                    if (amountController.text.isEmpty ||
                        companyController.text.isEmpty) {
                      Provider.of<Status>(context, listen: false)
                          .setStatus('Udfyld alle felter!');
                    } else {
                      if (await dBservice.checkBalanceOverZero(
                              iban, int.parse(amountController.text)) ==
                          true) {
                        CollectionReference users = FirebaseFirestore.instance
                            .collection('Transaction');
                        DateTime date = DateTime.now();
                        await users.add({
                          'amount': int.parse(amountController.text),
                          'beneficiary': companyController.text,
                          'creationDate':
                              "${date.day}-${date.month}-${date.year}",
                          'iban': iban
                        });
                        Navigator.pop(context);
                      } else {
                        Provider.of<Status>(context, listen: false)
                            .setStatus('Overtræk!');
                      }
                    }
                  },
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
                Text(Provider.of<Status>(context).status),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Status extends ChangeNotifier {
  String status = '';

  void setStatus(String status) {
    this.status = status;
    notifyListeners();
  }
}
