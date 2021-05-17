class Transaction {
  int? amount; // penge kan udtrykkes i øre -> bedre afrundinger
  DateTime? creationDate;
  String? beneficiary;
  int? iban;
  // konstructor og andre private getter og setter undladt
  Transaction({this.amount, this.creationDate, this.beneficiary, this.iban});
}
