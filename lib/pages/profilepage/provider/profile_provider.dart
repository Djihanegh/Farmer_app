import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:goldfarm/error/failure.dart';
import 'package:goldfarm/models/user_model.dart';
import 'package:goldfarm/pages/profilepage/services/profileservice.dart';


class ProfileProvider with ChangeNotifier{
  bool loading = false;

  Either<Failure, String> _fuser;

  Either<Failure, String> get fuser => _fuser;

  String _imageUrl;

  String get imageUrl => _imageUrl;

  Future<String> addUserProfile(User user,String uid) async {
    setLoading(true);
    await Task(() =>
        ProfileService.addUser(user, uid))
        .attempt()
        .map(
          (either) => either.leftMap((obj) {
        return obj as Failure;
      }),
    )
        .run()
        .then((value) => _setFuser(value));
  }

  Future uploadImage(File image,String path) async {
    setLoading(true);
   ProfileService.uploadFile(image, path).then((value){
     print("dvsjfhvbdsjhfjhsd $value");
     setImageUrl(value);
   });
    setLoading(false);
  }

  void setImageUrl(String value){
    _imageUrl = value;
    notifyListeners();
  }

  void _setFuser(Either<Failure,String> post) {
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