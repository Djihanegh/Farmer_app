import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:goldfarm/models/farmer_model.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/firestore_services.dart';
import 'package:goldfarm/utils/path.dart';

class FarmerRegisterService {
  static int length = 111111;
  static final service = FirestoreService.instance;
  static FirebaseDatabase database = new FirebaseDatabase();
  static DatabaseReference _checkRef = database.reference();
  static DatabaseReference _addRef = database.reference();
  static bool valuer;

  static Future<String> addFarmer(
      {String farmerId,
      String name,
      int age,
      String profile,
      FieldValue timestamp,
      String alter_mobile,
      String mobile,
      String agent_id,
      String gender}) async {
    _checkRef.child("FieldAgent Data").once().then((getCount) {
      print("Sucess");
      debugPrint("Sucess");
      Map data = getCount.value;
      var len = length + data.length;

      print("Length :${len}");

      _addRef.reference().child('FieldAgent Data').child(mobile).set(
          {'name': name, 'uid': farmerId, 'type': 'Farmer'}).whenComplete(() {
        return addFarmerCloud(
            Farmer(
                gf_code: len,
                timestamp: timestamp,
                name: name.toLowerCase(),
                profile: profile,
                alternet_mobile: alter_mobile,
                age: age,
                farmer_uid: farmerId,
                mobile: mobile,
                detail: "Pending",
                agent_id: agent_id,
                gender: gender),
            farmerId);
      });
    });
  }

  static Future uploadFile(File image, String path) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("$path/profile");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print("File Uploaded");
    var url = await storageReference.getDownloadURL();
    return url;
  }

  static Future<String> addFarmerCloud(Farmer farmer, String uid) async {
    await service.setData(
      path: FirestorePath.farmer(uid),
      data: farmer.toJson(),
    );
    print("Farmer Created");
    return "Farmer Created";
  }

  static Future<bool> validateNumber(String number) async {
    var onValue = await _checkRef.child("FieldAgent Data").child(number).once();

    if (onValue.value == null) {
      valuer = true;
    } else {
      valuer = false;
    }

    return valuer;
  }
}
