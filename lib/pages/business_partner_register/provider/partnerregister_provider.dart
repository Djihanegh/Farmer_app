import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:goldfarm/error/failure.dart';
import 'package:goldfarm/pages/business_partner_register/service/partnerregister_service.dart';
import 'package:goldfarm/pages/profilepage/services/profileservice.dart';

class PartnerRegisterProvider with ChangeNotifier {
  bool loading = false;

  Either<Failure, String> _fuser;

  Either<Failure, String> get fuser => _fuser;

  String _imageUrl;

  String get imageUrl => _imageUrl;

  Future<String> addPartnerProfile(
      String partnerId,
      String name,
      int age,
      String profile,
      FieldValue timestamp,
      String alter_mobile,
      String mobile, String agent_id, String gender) async {

    setLoading(true);
    await Task(() => PartnerRegisterService.addPartner(
            partnerId: partnerId,
            mobile: mobile,
            age: age,
            profile: profile,
            name: name,
            timestamp: timestamp,
            alter_mobile: alter_mobile,agent_id:agent_id,gender:gender))
        .attempt()
        .map(
          (either) => either.leftMap((obj) {
            return obj as Failure;
          }),
        )
        .run()
        .then((value) => _setFuser(value));
    setLoading(false);
  }

  Future<String> uploadImage(File image, String path) async {
    setLoading(true);
    return await ProfileService.uploadFile(image, path);
  }

  void setImageUrl(String value) {
    _imageUrl = value;
    notifyListeners();
  }

  void _setFuser(Either<Failure, String> post) {
    _fuser = post;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }
}
