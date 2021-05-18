class KontoTransaction {
  int? amount; // penge kan udtrykkes i øre -> bedre afrundinger
  DateTime? creationDate;
  String? beneficiary;
  int? iban;
  // konstructor og andre private getter og setter undladt
  KontoTransaction(
      {this.amount, this.creationDate, this.beneficiary, this.iban});
}
