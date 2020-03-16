import 'package:cloud_firestore/cloud_firestore.dart';

class Loan {
  final String acer;
  final String agent_uid;
  final String city;
  final String crop;
  final String farmer_uid;
  final String mobile;
  final String name;
  final int credit_limit;
  final int gf_code;
  final FieldValue timestamp;

  Loan(
      {this.acer,
      this.agent_uid,
      this.city,
      this.crop,
      this.farmer_uid,
      this.mobile,
      this.name,
      this.credit_limit,
      this.gf_code,
      this.timestamp});

  factory Loan.fromMap(Map<String, dynamic> json, String id) {
    return Loan(
      acer: json["acer"],
      agent_uid: json["agent_uid"],
      city: json["city"],
      crop: json["crop"],
      farmer_uid: json["farmer_uid"],
      mobile: json["mobile"],
      name: json["name"],
      credit_limit: json["credit_limit"],
      gf_code: json["gf_code"],
      timestamp: json["timestamp"],
    );
  }

  Map<String, dynamic> toJson() => {
        'acer':acer,
        'agent_uid':agent_uid,
        'city':city,
        'crop':crop,
        'farmer_uid':farmer_uid,
        'mobile':mobile,
        'name':name,
        'credit_limit':credit_limit,
        'gf_code':gf_code,
        'timestamp':timestamp
      };
}
