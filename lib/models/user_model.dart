import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String number;
  final String profile;
  final FieldValue timestamp;
  final String agent_uid;

  User(
      {this.name,
      this.email,
      this.number,
      this.profile,
      this.timestamp,
      this.agent_uid});

  factory User.fromMap(Map<String, dynamic> json, String id) {
    return User(
      name: json['name'],
      email: json['email'],
      number: json['number'],
      profile: json['profile'],
      timestamp: json['timestamp'],
      agent_uid: json['agent_uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'number': number,
        'profile': profile,
        'timestamp': timestamp,
        'agent_uid': agent_uid,
      };
}
