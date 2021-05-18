import 'Kind.dart';
import 'Transaction.dart';

class Account {
  String name;
  String iban;
  String kind;
  List<KontoTransaction> transactions;
  // konstructor og andre private getter og setter undladt
  // saldo kan f.eks. være en getter hvor du med HOF reduce lægger
  // alle transaktioner sammen
  Account(
      {required this.name,
      required this.iban,
      required this.kind,
      required this.transactions});
}
