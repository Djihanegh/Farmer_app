class FirestorePath {
  static String user(String uid) => 'Field Agent/$uid/';
  static String farmer(String farmerid) => 'Farmer/$farmerid/';
  static String farmers() => 'Farmer';
  static String partner(String partnerid) => 'Business Partner/$partnerid/';
  static String partners() => 'Business Partner';
  static String crop(String cropName) => 'Crops/$cropName/';
  static String crops() => 'Crops';
  static String loan() => 'Loan/';
}