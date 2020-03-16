import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Partner {
  final String partner_uid;
  final int age;
  final String alternet_mobile;
  final int gf_code;
  final String mobile;
  final String name;
  final String profile;
  final FieldValue timestamp;
  final double latitude;
  final double longitude;
  final String state;
  final String district;
  final String city;
  final String taluka;
  final String village;
  final String detail;
  final String agent_id;
  final String gender;

  Partner(
      {this.partner_uid,
      this.age,
      this.alternet_mobile,
      this.gf_code,
      this.mobile,
      this.name,
      this.profile,
      this.timestamp,
      this.latitude,
      this.longitude,
      this.state,
      this.district,
      this.city,
      this.taluka,
      this.village,
      this.detail,
      this.agent_id,
      this.gender
      });

  factory Partner.fromMap(Map<String, dynamic> json, String id) {
    return Partner(
        partner_uid: json['partner_uid'],
        age: json['age'],
        alternet_mobile: json['alternet_mobile'],
        gf_code: json['gf_code'],
        name: json['name'],
        profile: json['profile'],
        timestamp: json['timestamp'],
        mobile: json["mobile"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        state: json["state"],
        district: json["district"],
        city: json["city"],
        taluka: json["taluka"],
        village: json["village"],
        detail: json["detail"],
        agent_id: json["agent_id"],
        gender: json['gender']
    );
  }

  Map<String, dynamic> toJson() => {
        'partner_uid': partner_uid,
        'age': age,
        'alternet_mobile': alternet_mobile,
        'gf_code': gf_code,
        'name': name,
        'profile': profile,
        'timestamp': timestamp,
        'mobile': mobile,
        'latitude': latitude,
        'longitude': longitude,
        'state': state,
        'district': district,
        'city': city,
        'taluka': taluka,
        'village': village,
        'detail': detail,
        'agent_id':agent_id,
        'gender':gender
      };
}
