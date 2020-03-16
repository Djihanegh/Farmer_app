import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldfarm/utils/path.dart';

class FarmerSubRegisterService {
  static void updateFarmer(double lat, double long, String state,
      String district, String city, String taluka, String village, String fid) {
    Firestore.instance.collection('Farmer').document(fid).updateData({
      "latitude": lat,
      "longitude": long,
      "state": state,
      "district": district,
      "city": city,
      "taluka": taluka,
      "village": village
    }).then((result) {
      print("new User true");
    }).catchError((onError) {
      print("onError");
    });
  }
}
