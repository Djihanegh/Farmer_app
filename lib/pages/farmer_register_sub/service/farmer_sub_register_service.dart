import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerSubRegisterService {
  static void updatePartner(double lat, double long, String state,
      String district, String city, String taluka, String village, String fid,String category,String turnover) {
    Firestore.instance.collection('Business Partner').document(fid).updateData({
      "latitude": lat,
      "longitude": long,
      "state": state,
      "district": district,
      "city": city,
      "taluka": taluka,
      "village": village,
      "category": category,
      "turnover": turnover
    }).then((result) {
      print("new USer true");
    }).catchError((onError) {
      print("onError");
    });
  }
}
