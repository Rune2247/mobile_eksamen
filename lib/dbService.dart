import 'package:cloud_firestore/cloud_firestore.dart';

class DBservice {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> accountStream() {
    return _db.collection('Account').snapshots();
  }

  Future<int> newAcountNumber() async {
    QuerySnapshot querySnapshot = await _db.collection('Account').get();

    return querySnapshot.docs.length + 1;
  }

  Stream<QuerySnapshot> kindStream() {
    return _db.collection('Kind').snapshots();
  }

  Stream<QuerySnapshot> transferStreamForAccount(String iban) {
    return _db
        .collection('Transaction')
        .where('iban', isEqualTo: iban)
        .snapshots();
  }

  Future<int> getAccountBalance(String iban) async {
    print('Kør');
    int sum = 0;
    QuerySnapshot querySnapshot = await _db.collection('Transaction').get();

    querySnapshot.docs.forEach((doc) {
      if (doc["iban"] == iban) {
        sum += doc["amount"] as int;
      }
    });

    return sum;
  }

  Future<bool> checkBalanceOverZero(String iban, int newAmount) async {
    int balance = await getAccountBalance(iban);
    if (newAmount + balance < 0) {
      print('False ${newAmount + balance}');
      return false;
    }
    print('True ${newAmount + balance}');
    return true;
  }
}
