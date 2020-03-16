import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:goldfarm/models/user_model.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/firestore_services.dart';
import 'package:goldfarm/utils/path.dart';
import 'package:path/path.dart' as Path;

class ProfileService {
  static final service = FirestoreService.instance;

  static Future<String> addUser(User user, String uid) async {
    await service.setData(
      path: FirestorePath.user(uid),
      data: user.toJson(),
    );
    return "User Created";
  }

  static Future uploadFile(File image,String path) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("$path/profile");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    var url = await storageReference.getDownloadURL();
    return url;
  }
}
